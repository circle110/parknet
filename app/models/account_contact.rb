class AccountContact < ActiveRecord::Base
	belongs_to :agency
	belongs_to :account
	belongs_to :customer # ie head of household
	belongs_to :address

	
  # attr_accessible :title, :body
end
