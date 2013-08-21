class Registration < ActiveRecord::Base
	belongs_to :agency
	belongs_to :customer
	belongs_to :class_session
	belongs_to :program
	has_one :accounting_transaction, as: :reference
	
	attr_accessible :agency_id, :customer_id, :class_session_id, :user_stamp, :fee_amount, :creation_user_stamp, :status_id
	
	validates :agency_id, :customer_id, :user_stamp, :creation_user_stamp,:fee_amount, :class_session_id, :presence => true
	validates_uniqueness_of :customer_id, :scope => :class_session_id, :message => ' selected is already registered for that class.'
	
	after_save :create_accounting_transaction
	after_save :update_class_num_registered
	after_save :update_customer_account_balance

	
	def create_accounting_transaction
		class_session = ClassSession.find(class_session_id)
		class_session_fund_id = class_session.gl_account.fund_id
		case status_id 
			when "a" 
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
					:transaction_type_id => 1, #type 1 is a registration
					:user_stamp => user_stamp,	
					:debit_gl_account_id => debit_gl_account_id,
					:credit_gl_account_id => credit_gl_account_id,
					:customer_account_id => customer_id,
					:debit => fee_amount,
					:credit => fee_amount
				)
				accounting_transaction.save
			when "l"
				# Nothing happens to accounting_transactions
			when "w"
				original_accounting_transaction = AccountingTransaction.where("reference_id = ? AND transaction_type_id = 1", id)
				# set debit gl to customer account balances for this fund - #3 is the customer account balances account_type 
				customer_account_balance_gl = GlAccount.where("agency_id = #{agency_id} AND account_type = 3 and fund_id = #{class_session_fund_id}")
				credit_gl_account_id = customer_account_balance_gl.first.id
				if class_session.start_date > Date.today  # set debit gl to deferred gl of original registration if the class starts in the future
					debit_gl_account_id = original_accounting_transaction.first.credit_gl_account_id
				else  # set debit gl to program revenue if the class has already started
					debit_gl_account_id = class_session.gl_account_id
				end
				amount = original_accounting_transaction.first.credit
				accounting_transaction = AccountingTransaction.new(
					:agency_id => agency_id,
					:reference_id => id,
					:transaction_type_id => 3, #type 3 is a withdrawal
					:user_stamp => user_stamp,	
					:debit_gl_account_id => debit_gl_account_id,
					:credit_gl_account_id => credit_gl_account_id,
					:customer_account_id => original_accounting_transaction.first.customer_account_id,
					:debit => amount,
					:credit => amount
				)
				accounting_transaction.save
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
					:transaction_type_id => 1, #type 1 is a registration
					:user_stamp => user_stamp,	
					:debit_gl_account_id => debit_gl_account_id,
					:credit_gl_account_id => credit_gl_account_id,
					:customer_account_id => customer_id,
					:debit => fee_amount,
					:credit => fee_amount
				)
				accounting_transaction.save
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
