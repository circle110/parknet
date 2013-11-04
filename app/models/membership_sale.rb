class MembershipSale < ActiveRecord::Base
	
	belongs_to :agency
	belongs_to :membership
	belongs_to :customer

	attr_accessible :agency_id, :location_id, :membership_id, :customer_id, :membership_fee_id, :fee_amount, :subscription_flag, :start_date, :expiry_date, :creation_user_stamp, :user_stamp

	
	validates :agency_id, :membership_id, :customer_id, :membership_fee_id, :fee_amount, :subscription_flag, :start_date, :expiry_date, :creation_user_stamp, :user_stamp, :presence => true
	
	validate :membership_exists
	validate :no_duplicate_memberships
	after_create :create_accounting_transaction

	
	def no_duplicate_memberships
	right_now = Time.now
		@previous_memberships = MembershipSale.where("customer_id = ? AND membership_id = ?", customer_id, membership_id).order(:expiry_date)
		expiry_date = @previous_memberships.last.nil? ? '1/1/1900':@previous_memberships.last.expiry_date
		if right_now - expiry_date.to_time < 0
			errors[:base] << 'Customer selected has that membership currently.'
		end
	end
	
	def membership_exists
		return false if Membership.find(membership_id).nil?
	end
	
	def create_accounting_transaction
		membership = Membership.find(membership_id)
		membership_gl_account_id = membership.gl_account_id
		membership_fund_id = membership.gl_account.fund_id
		# set debit gl to customer account balances for this fund - #3 is the customer account balances account_type 
		customer_account_balance_gl = GlAccount.where("agency_id = #{agency_id} AND account_type = 3 and fund_id = #{membership_fund_id}")
		debit_gl_account_id = customer_account_balance_gl.first.id
		
		date_today = Date.today
		fye = Date.new(date_today.strftime("%Y").to_i, agency.fiscal_year_end_month, agency.fiscal_year_end_day)
		if fye < date_today
			fye += 1.year
		end
		if expiry_date > fye  # see if deferral is required
			deferred_gl_account_id = membership.deferred_gl_account_id
			if start_date > fye # see if 100% of membership is in next fy for 100% deferral
				credit = fee_amount
			else # if not, figure split of deferred gl/course gl if the membership crosses fiscal year end
				days_this_fy = fye - start_date #calculate days this fy
				days_next_fy = expiry_date - fye #calculate days next fy
				total_membership_days = days_this_fy + days_next_fy
				amount_to_revenue =  fee_amount*days_this_fy/total_membership_days.to_f #do math to calculate how much $ to program revenu
				amount_deferred = fee_amount*days_next_fy/total_membership_days.to_f  #do math to calculate how much $ to deferred
				amount_to_revenue = amount_to_revenue.round(2)
				amount_deferred = amount_deferred.round(2)
				accounting_transaction_deferral = AccountingTransaction.new(
					:agency_id => agency_id,
					:location_id => location_id,
					:reference_id => id,
					:reference_type => 'Membership',
					:transaction_type_id => 6, #type 6 is a membership pass
					:user_stamp => user_stamp,	
					:debit_gl_account_id => debit_gl_account_id,
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
		
		accounting_transaction = AccountingTransaction.new(
			:agency_id => agency_id,
			:location_id => location_id,
			:reference_id => id,
			:reference_type => 'MembershipSale',
			:transaction_type_id => 6, #type 6 is a membership pass sale
			:user_stamp => user_stamp,	
			:debit_gl_account_id => debit_gl_account_id,
			:credit_gl_account_id => membership_gl_account_id,
			:customer_id => customer_id,
			:debit => debit,
			:credit => credit
		)
		accounting_transaction.save
	end
	
	
end
