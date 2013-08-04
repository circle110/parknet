class RegistrationBasket < ActiveRecord::Base
	belongs_to :agency
	belongs_to :customer
	has_many :registration_basket_line_items
	
	attr_accessible :agency_id, :customer_id, :registration_basket_line_item
	

end
