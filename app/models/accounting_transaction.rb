class AccountingTransaction < ActiveRecord::Base

	belongs_to :reference, polymorphic: true


  attr_accessible :agency_id, :user_stamp, :debit_gl_account_id, :credit_gl_account_id, :customer_account_id, :debit, :credit, :reference_id, :transaction_type_id
  
  
end
