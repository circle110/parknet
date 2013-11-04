class MembershipFee < ActiveRecord::Base
include ActionView::Helpers::NumberHelper

	belongs_to :agency
	belongs_to :membership
	
	attr_accessible :agency_id, :membership_id, :name, :amount, :active, :user_stamp
	
	def name_fee
		number_to_currency(amount) + " || " + name 
	end
end
