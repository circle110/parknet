class AccountingTransaction < ActiveRecord::Base


  attr_accessible :agency_id, :user_stamp, :debit_gl_account_id, :credit_gl_account_id, :customer_account_id, :debit, :credit
  
  
end
