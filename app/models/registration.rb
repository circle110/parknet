class Registration < ActiveRecord::Base
	include ActiveModel::Dirty
	
	belongs_to :agency
	belongs_to :customer
	belongs_to :class_session
	belongs_to :program
	has_many :payment_allocations, as: :reference
	has_many :accounting_transactions, as: :reference
	has_many :refunds, as: :refund_for

	
	attr_accessible :agency_id, :customer_id, :class_session_id, :user_stamp, :fee_amount, :unpaid_balance, :creation_user_stamp, :status_id
	attr_accessor :withdrawal_fee
	
	validates :agency_id, :customer_id, :user_stamp, :creation_user_stamp,:fee_amount, :class_session_id, :presence => true
	validates_uniqueness_of :customer_id, :scope => [:class_session_id, :status_id], :message => ' selected is already registered for that class.'
	
	after_create :create_accounting_transaction
	after_create :update_class_num_registered
	after_create :update_customer_account_balance
	
	after_update :create_accounting_transaction, :if => :status_change
	after_update :update_class_num_registered, :if => :status_change

	def status_change
		status_id_changed?
	end
	
	def already_in_class
		
	end
	
	def create_accounting_transaction
		class_session = ClassSession.find(class_session_id)
		class_session_fund_id = class_session.gl_account.fund_id
		agency = Agency.find(agency_id)
		case status_id 
			when "a" 
				# find gl for customer account balances for this fund - #3 is the customer account balances account_type 
				customer_account_balance_gl = GlAccount.where("agency_id = #{agency_id} AND account_type = 3 and fund_id = #{class_session_fund_id}") 
				customer_balance_gl_account_id = customer_account_balance_gl.first.id
				date_today = Date.today
				fye = Date.new(date_today.strftime("%Y").to_i, agency.fiscal_year_end_month, agency.fiscal_year_end_day)
				if fye < date_today
					fye += 1.year
				end
				if class_session.end_date > fye  # see if deferral is required
					deferred_gl_account_id = class_session.deferred_gl_account_id
					if class_session.start_date > fye # see if 100% of class is in next fy for 100% deferral
						credit = fee_amount
					else # if not, figure split of deferred gl/course gl if the class crosses fiscal year end
						days_this_fy = fye - class_session.start_date #calculate days this fy
						days_next_fy = class_session.end_date - fye #calculate days next fy
						total_class_days = days_this_fy + days_next_fy
						amount_to_revenue =  fee_amount*days_this_fy/total_class_days.to_f #do math to calculate how much $ to program revenu
						amount_deferred = fee_amount*days_next_fy/total_class_days.to_f  #do math to calculate how much $ to deferred
						amount_to_revenue = amount_to_revenue.round(2)
						amount_deferred = amount_deferred.round(2)
						accounting_transaction_deferral = AccountingTransaction.new(
							:agency_id => agency_id,
							:location_id => location_id,
							:reference_id => id,
							:reference_type => 'Registration',
							:transaction_type_id => 1, #type 1 is a registration
							:user_stamp => user_stamp,	
							:debit_gl_account_id => customer_balance_gl_account_id,
							:credit_gl_account_id => deferred_gl_account_id,
							:customer_id => customer_id,
							:debit => amount_deferred,
							:credit => amount_deferred
						)
						accounting_transaction_deferral.save
						credit = amount_to_revenue
						debit = amount_to_revenue
					end	
				else  # if deferral is not required			
					credit = fee_amount
					debit = fee_amount
				end
				# add accounting transaction that is either the only accounting transaction if all is deferred or deferral not involved or is the 2nd half of the partial deferral situation.
				program_gl_account_id = class_session.gl_account_id
				accounting_transaction = AccountingTransaction.new(
					:agency_id => agency_id,
					:reference_id => id,
					:reference_type => 'Registration',
					:transaction_type_id => 1, #type 1 is a registration
					:user_stamp => user_stamp,	
					:debit_gl_account_id => customer_balance_gl_account_id,
					:credit_gl_account_id => program_gl_account_id,
					:customer_id => customer_id,
					:debit => debit,
					:credit => credit
				)
				accounting_transaction.save
			when "l"
				# Nothing happens to accounting_transactions
			when "w"
				original_accounting_transaction = AccountingTransaction.where("reference_id = ? AND transaction_type_id = 1", id)
				# set credit gl to customer account balances for this fund - #3 is the customer account balances account_type 
				customer_account_balance_gl = GlAccount.where("agency_id = #{agency_id} AND account_type = 3 and fund_id = #{class_session_fund_id}")
				credit_gl_account_id = customer_account_balance_gl.first.id		
				original_transaction_count = original_accounting_transaction.count
				original_program = ClassSession.find(class_session_id)
				if original_transaction_count == 1
					if original_accounting_transaction.first.deferred == 1 # started out 100% deferred and still is
						#reversal goes to deferred revenue - basically reverse the original
						accounting_transaction_deferral_reversal = AccountingTransaction.new(
							:agency_id => agency_id,
							:reference_id => id,
							:reference_type => 'Registration',
							:transaction_type_id => 3, #type 3 is a withdrawal
							:user_stamp => user_stamp,	
							:debit_gl_account_id => original_accounting_transaction.credit_gl_account_id,
							:credit_gl_account_id => original_accounting_transaction.debit_gl_account_id,
							:customer_id => customer_id,
							:debit => original_accounting_transaction.credit,
							:credit => original_accounting_transaction.debit
						)
						accounting_transaction_deferral_reversal.save
					else # may have been deferred and reversed or perhaps was never deferred
						#reversal goes to program revenue
						amount = original_accounting_transaction.first.credit
						debit_gl_account_id = original_program.gl_account_id
					end
				elsif original_transaction_count == 2
					deferred_record = original_accounting_transaction.exists?(:deferred => 1)
					if deferred_record
						#one reversal goes to deferred revenue
						original_accounting_transaction.each do |o|
							if o.deferred == 1 # started out partially deferred and still is. Reversal goes to deferred revenue, basically reverse the original.
								accounting_transaction_deferral_reversal = AccountingTransaction.new(
									:agency_id => agency_id,
									:reference_id => id,
									:reference_type => 'Registration',
									:transaction_type_id => 3, #type 3 is a withdrawal
									:user_stamp => user_stamp,	
									:debit_gl_account_id => o.credit_gl_account_id,
									:credit_gl_account_id => o.debit_gl_account_id,
									:customer_id => customer_id,
									:debit => o.credit,
									:credit => o.debit
								)
								accounting_transaction_deferral_reversal.save
							else
								#one reversal goes to program revenue
								amount = o.credit
								debit_gl_account_id = original_program.gl_account_id
							end
						end
					else
						#sum amount of both records
						amount = 0
						original_accounting_transaction.each do |o|
							amount += o.credit
						end
						#single reversal goes to program revenue
						debit_gl_account_id = original_program.gl_account_id
					end
				else
					#oops
				end
				
				accounting_transaction_withdrawal = AccountingTransaction.new(
					:agency_id => agency_id,
					:reference_id => id,
					:reference_type => 'Registration',
					:transaction_type_id => 3, #type 3 is a withdrawal
					:user_stamp => user_stamp,	
					:debit_gl_account_id => debit_gl_account_id,
					:credit_gl_account_id => credit_gl_account_id,
					:customer_id => customer_id,
					:debit => amount,
					:credit => amount
				)
				accounting_transaction_withdrawal.save
						
			when "d"
				# Nothing happens to accounting_transactions
			when "u"
				# set debit gl to customer account balances for this fund - #3 is the customer account balances account_type 
				customer_account_balance_gl = GlAccount.where("agency_id = #{agency_id} AND account_type = 3 and fund_id = #{class_session_fund_id}") 
				debit_gl_account_id = customer_account_balance_gl.first.id
				if class_session.start_date > Date.today  # set credit gl to deferred gl if the class starts in the future
					credit_gl_account_id = class_session.deferred_gl_account_id
				else  # set credit gl to program revenue if the class has already started
					credit_gl_account_id = class_session.gl_account_id
				end
				accounting_transaction = AccountingTransaction.new(
					:agency_id => agency_id,
					:reference_id => id,
					:reference_type => 'Registration',
					:transaction_type_id => 1, #type 1 is a registration
					:user_stamp => user_stamp,	
					:debit_gl_account_id => debit_gl_account_id,
					:credit_gl_account_id => credit_gl_account_id,
					:customer_id => customer_id,
					:debit => fee_amount,
					:credit => fee_amount
				)
				accounting_transaction.save
			else
		end		
	end
	
	def update_customer_account_balance
		customer = Customer.find(customer_id)
		case status_id
			when "a" #active, meaning a new registration
				customer.current_account_balance += fee_amount.to_f
			when "w" #withdraw
				customer.current_account_balance -= fee_amount.to_f	
			when "d" #was on wailtist but is withdrawing
				#Do nothing besides update registration record
			when "l"
				#Do nothing besides create registration record and update waitlist count
			when "u" #un-waitlist the registrant
				customer.current_account_balance += fee_amount.to_f	
		end
		customer.save
	end
	
	def update_class_num_registered
		class_session = ClassSession.find(class_session_id)
		case status_id
			when "a" # a new registration
				class_session.number_registered = class_session.number_registered + 1
			when "l" # put on waitlist
				class_session.number_waitlisted += 1
			when "w" # withdrawing from a class
				class_session.number_registered -= 1
			when "d" # was on waitlist but is withdrawing
				class_session.number_waitlisted -= 1
			when "u" #un-waitlisting, ie moving the registrant from the waitlist to the class list
				class_session.number_waitlisted -= 1
				class_session.number_registered += 1
		end
		class_session.save
	end
	

end
