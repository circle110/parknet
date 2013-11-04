class PaymentAllocation < ActiveRecord::Base
	belongs_to :agency
	has_one :accounting_transaction, as: :reference 
	belongs_to :payment
	belongs_to :registration
	belongs_to :reference, polymorphic: true

	attr_accessor :class_session_id
	attr_accessor :customer_id
	attr_accessor :amount_from_account
	attr_accessor :cab_fund
	
	validates :agency_id, :reference_id, :user_stamp, :amount, :presence => true
	
	attr_accessible :agency_id, :payment_id, :reference_id, :user_stamp, :amount, :class_session_id, :customer_id, :creation_user_stamp, :amount_from_account, :cab_fund
  
  	after_create :create_accounting_transaction, :if => :amount_greater_than_zero
	after_create :update_registration_unpaid_balance, :if => :amount_greater_than_zero
	#after_create :create_allocation_from_cab, :if => :amount_from_account
	after_create :create_due_to_due_from, :if => :using_cab_money_from_another_fund
	
	def using_cab_money_from_another_fund
		registration = Registration.find(reference_id)
		@registration_fund = registration.class_session.gl_account.fund_id
		if !amount_from_account.blank? && cab_fund != @registration_fund
			return true
		else
			return false
		end	
	end
	
	def amount_greater_than_zero
		if amount > 0
			return true
		end
	end
  
  	def create_accounting_transaction
		class_session = ClassSession.find(class_session_id)
		class_session_fund_id = class_session.gl_account.fund_id
		# set debit gl to cash account
		cash_account = GlAccount.where("agency_id = ? AND fund_id = ? AND account_type = 6", agency_id, class_session_fund_id) #6 is the cash account account_type
		debit_gl_account_id = cash_account.first.id
		# set credit gl to customer balances account. #3 is the customer account balances account_type
		customer_account_balance_gl = GlAccount.where("agency_id = ? AND fund_id = ? AND gl_accounts.account_type = 3", agency_id, class_session_fund_id)
		credit_gl_account_id = customer_account_balance_gl.first.id
		reference_id = id
		
		@accounting_transaction = AccountingTransaction.new(
		:agency_id => agency_id,
		:reference_id => id,
		:reference_type => 'PaymentAllocation',
		:transaction_type_id => 2, #type 2 is a payment allocation
		:user_stamp => user_stamp,
		:debit_gl_account_id => debit_gl_account_id,
		:credit_gl_account_id => credit_gl_account_id,
		:customer_id => customer_id,
		:debit => amount,
		:credit => amount
		)
		@accounting_transaction.save
	end

	
	def update_registration_unpaid_balance
		@registration = Registration.find(reference_id) # reference_id is the registration_id of the registration being paid on.
		@registration.unpaid_balance -= amount
		@registration.save
	end
	
	def create_due_to_due_from
		cab_gl_previous_fund  = GlAccount.where("fund_id = ? AND account_type = 3", cab_fund)
		cab_gl_new_fund = GlAccount.where("fund_id = ? AND account_type = 3", @registration_fund)
		due_to_due_from  = AccountingTransaction.new(
			:agency_id => agency_id,
			:reference_id => id,
			:reference_type => 'Registration',
			:transaction_type_id => 9, #type 9 is a due to due from
			:user_stamp => user_stamp,	
			:debit_gl_account_id => cab_gl_previous_fund.first.id,
			:credit_gl_account_id => cab_gl_new_fund.first.id,
			:customer_id => customer_id,
			:debit => amount_from_account,
			:credit => amount_from_account
		)
		due_to_due_from.save
	end
end
