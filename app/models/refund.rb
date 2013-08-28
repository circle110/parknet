class Refund < ActiveRecord::Base

	belongs_to :agency
	belongs_to :accounting_transaction
	
	
  # attr_accessible :title, :body
end
