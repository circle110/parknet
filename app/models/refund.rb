class Refund < ActiveRecord::Base

	belongs_to :agency
	belongs_to :accounting_transaction
	belongs_to :refund_for, polymorphic: true
	
	attr_accessible :agency_id, :reference_id, :reference_type, :status_id, :amount, :creation_user_stamp, :user_stamp
  
	after_update :create_accounting_transaction_processed, :if => :refund_just_processed
	after_update :create_accounting_transaction_unrequested, :if => :refund_unrequested
	after_update :update_amount_refunded, :if => :refund_just_processed
	#after_update :update_customer_account_balance, :if => :refund_just_processed
	
	after_create :create_accounting_transaction_requested
	
	# status ids
	# 0 unrequested
	# 1 requested
	# 2 processed
	
	def refund_just_processed
		status_id == 2 && status_id_was != 2
	end
	
	def refund_unrequested
		status_id == 0 && status_id_was != 0
	end
	
	def create_accounting_transaction_processed
		original_registration = Registration.find(reference_id)
		original_accounting_transaction = AccountingTransaction.where("reference_id = ? and reference_type = 'Registration'", reference_id)
		program_gl = GlAccount.find(original_accounting_transaction.first.credit_gl_account_id)
		fund = program_gl.fund_id
		refunds_pending_account_gl = GlAccount.where("fund_id = ? AND account_type = 8", fund)
		cash_account_gl = GlAccount.where("fund_id = ? AND account_type = 6", fund)
		customer_id = original_registration.customer_id
		debit_gl_account_id = refunds_pending_account_gl.first.id #refunds pending account of appropriate fund
		credit_gl_account_id = cash_account_gl.first.id #cash account of appropriate fund
		accounting_transaction = AccountingTransaction.new(
			:agency_id => agency_id,
			:reference_id => id,
			:reference_type => 'Refund',
			:transaction_type_id => 5, #type 5 is a refund processed
			:user_stamp => user_stamp,
			:debit_gl_account_id => debit_gl_account_id,
			:credit_gl_account_id => credit_gl_account_id,
			:customer_id => customer_id,
			:debit => amount,
			:credit => amount,
			:no_download => 1
		)
		accounting_transaction.save
	end
	
	def create_accounting_transaction_requested
		original_registration = Registration.find(reference_id)
		original_accounting_transaction = AccountingTransaction.where("reference_id = ? and reference_type = 'Registration'", reference_id)
		program_gl = GlAccount.find(original_accounting_transaction.first.credit_gl_account_id)
		fund = program_gl.fund_id
		customer_account_balance_gl = GlAccount.where("fund_id = ? AND account_type = 3", fund)
		refunds_pending_account_gl = GlAccount.where("fund_id = ? AND account_type = 8", fund)
		customer_id = original_registration.customer_id
		debit_gl_account_id = customer_account_balance_gl.first.id #customer account balance gl for fund
		credit_gl_account_id = refunds_pending_account_gl.first.id #refunds pending account
		accounting_transaction = AccountingTransaction.new(
			:agency_id => agency_id,
			:reference_id => id,
			:reference_type => 'Refund',
			:transaction_type_id => 4, #type 4 is a refund request
			:user_stamp => user_stamp,
			:debit_gl_account_id => debit_gl_account_id,
			:credit_gl_account_id => credit_gl_account_id,
			:customer_id => customer_id,
			:debit => amount,
			:credit => amount
		)
		accounting_transaction.save
	end
	
	def create_accounting_transaction_unrequested
		original_registration = Registration.find(reference_id)
		original_accounting_transaction = AccountingTransaction.where("reference_id = ? and reference_type = 'Registration'", reference_id)
		program_gl = GlAccount.find(original_accounting_transaction.first.credit_gl_account_id)
		fund = program_gl.fund_id
		customer_account_balance_gl = GlAccount.where("fund_id = ? AND account_type = 3", fund)
		refunds_pending_account_gl = GlAccount.where("fund_id = ? AND account_type = 8", fund)
		customer_id = original_registration.customer_id
		credit_gl_account_id = customer_account_balance_gl.first.id #customer account balance gl for fund
		debit_gl_account_id = refunds_pending_account_gl.first.id #refunds pending account
		accounting_transaction = AccountingTransaction.new(
			:agency_id => agency_id,
			:reference_id => id,
			:reference_type => 'Refund',
			:transaction_type_id => 7, #type 7 is a refund unrequest
			:user_stamp => user_stamp,
			:debit_gl_account_id => debit_gl_account_id,
			:credit_gl_account_id => credit_gl_account_id,
			:customer_id => customer_id,
			:debit => amount,
			:credit => amount
		)
		accounting_transaction.save
	end
	
	def update_amount_refunded
		registration = Registration.find(reference_id)
		registration.amount_refunded = amount
		registration.save
	end
	
	def update_customer_account_balance
	
	end
	
	
	
end
