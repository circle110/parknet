class RegistrationBasket < ActiveRecord::Base
	belongs_to :agency
	belongs_to :account
	has_many :registration_basket_line_items
	
	attr_accessible :agency_id, :account_id, :status_id
	
	validates :agency_id, :account_id, :status_id, :presence => true
	

end
