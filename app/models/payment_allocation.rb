class PaymentAllocation < ActiveRecord::Base
	belongs_to :agency
	has_one :accounting_transaction, as: :reference 
	belongs_to :payment
	belongs_to :reference, polymorphic: true

	attr_accessor :class_session_id
	attr_accessor :customer_id
	
	validates :agency_id, :allocation_type, :reference_id, :user_stamp, :amount, :presence => true
	
	attr_accessible :agency_id, :payment_id, :reference_id, :allocation_type, :user_stamp, :amount, :class_session_id, :customer_id, :creation_user_stamp
  
  	after_save :create_accounting_transaction
	after_save :update_customer_account_balance
	after_save :update_registration_unpaid_balance
  
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
		:transaction_type_id => 2, #type 2 is a payment allocation
		:user_stamp => user_stamp,
		:debit_gl_account_id => debit_gl_account_id,
		:credit_gl_account_id => credit_gl_account_id,
		:customer_account_id => customer_id,
		:debit => amount,
		:credit => amount
		)
		@accounting_transaction.save
	end
	
	def update_customer_account_balance
		@customer = Customer.find(customer_id)
		@customer.current_account_balance -= amount
		@customer.save
	end
	
	def update_registration_unpaid_balance
		@registration = Registration.find(reference_id) # reference_id is the registration_id of the registration being paid on.
		@registration.unpaid_balance -= amount
		@registration.save
	end
end
