class Facility < ActiveRecord::Base
	belongs_to :agency
	belongs_to :facility_type
	has_many :child_facilities, :class_name => "Facility",
								:foreign_key => :parent_facility_id
	belongs_to :parent_facilty, :class_name => "Facility"
	
	belongs_to :staff_supervisor
	belongs_to :gl_account
	has_many :facility_bookings
	
	
	attr_accessible :agency_id, :facility_type_id, :facility_supervisor_id, :name, :parent_facility_id, :gl_account_id, :user_stamp, :internet_query_flag, 
	:deposit_required_flag, :internet_availability_flag, :active, :deposit_amount, :alert_text, :confirmation_text, :description
	#scope :parent_facilities, where(:parent_facility_id => nil)
end
