class ClassSession < ActiveRecord::Base
	belongs_to :agency
	belongs_to :program
	belongs_to :season
	belongs_to :staff_user
	belongs_to :facility
	has_many :facility_bookings
	belongs_to :gl_account
	belongs_to :deferred_gl_account
	has_many :class_session_fees
	has_many :registrations

	
	attr_accessible :agency_id, :program_id, :season_id, :name, :session_display_order, :session_status_id, :facility_id, :start_date, :end_date,
	:start_time, :end_time, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :number_of_bookings, :supervisor_id, :registration_start_datetime, :minimum_registrants, 
	:maximum_registrants, :number_registered, :number_waitlisted, :cancel_datetime, :cancel_reason, :gl_account_id, :deferred_gl_account_id, :minimum_age, :maximum_age, 
	:minimum_age_type, :maximum_age_type, :internet_display_date, :internet_display_until_date, :member_registration_start_date, :non_resident_registration_start_date, 
	:alert_text, :confirmation_text, :description, :user_stamp
	
end
