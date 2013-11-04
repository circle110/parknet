class Booking < ActiveRecord::Base
	belongs_to :agency
	

	attr_accessible :agency_id, :booking_date, :start_time, :end_time, :facility_id, :class_session_id, :user_stamp
	
end
