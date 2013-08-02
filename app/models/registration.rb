class Registration < ActiveRecord::Base
	belongs_to :agency
	belongs_to :customer
	belongs_to :class_session
	
	attr_accessible :agency_id, :customer_id, :class_session, :user_stamp
	

end
