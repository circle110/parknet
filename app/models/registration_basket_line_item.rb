class RegistrationBasketLineItem < ActiveRecord::Base
	belongs_to :agency
	belongs_to :registration_basket
	belongs_to :class_session
	
	attr_accessible :agency_id, :registration_basket_id, :class_session_id
	
end
