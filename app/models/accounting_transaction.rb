class AccountingTransaction < ActiveRecord::Base

	belongs_to :reference, polymorphic: true
	belongs_to :customer

	attr_accessible :agency_id, :location_id, :user_stamp, :debit_gl_account_id, :credit_gl_account_id, :customer_id, :debit, :credit, :reference_id, :reference_type, :transaction_type_id, :no_download
	
	# Transaction type IDs
	# 1 Registration
	# 2 Payment Allocation
	# 3 Withdraw from Program
	# 4	Refund Request
	# 5 Refund Processed
	# 6 Membership Pass
	# 7 Refund Unrequest
	# 8 Additional Fee
	# 9 Due To Due From
  
  
end
