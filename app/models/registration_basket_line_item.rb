class RegistrationBasketLineItem < ActiveRecord::Base
	belongs_to :agency
	belongs_to :registration_basket
	belongs_to :class_session
	belongs_to :customer
	
	attr_accessible :agency_id, :registration_basket_id, :class_session_id, :customer_id, :fee_amount, :waitlist_flag
	
	validates :agency_id, :registration_basket_id, :class_session_id, :customer_id, :fee_amount, :presence => true
	validate :not_already_registered, :message => 'Customer selected is already registered for that class.'

	#before_validation :not_already_registered, :message => ' selected is already registered for that class.'
	
	
	def not_already_registered
		registration = Registration.where("customer_id = ? AND class_session_id = ?", customer_id, class_session_id)
		if registration.count >= 1
			errors.add(:customer_id, " selected is already registered for that class.")
		end
	end
	
end
