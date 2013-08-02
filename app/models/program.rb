class Program < ActiveRecord::Base
	belongs_to :agency
	belongs_to :brochure_section
	has_one :brochure_subsection 
	has_many :class_sessions
	has_many :class_session_fees, through: :class_sessions
	has_one :deferred_gl_account
	
	
	attr_accessible :agency_id, :brochure_section_id, :brochure_subsection_id, :code, :name, :min_age, :min_age_type, :max_age, :max_age_type, :default_minimum_registrants,
	:default_maximum_registrants, :scheduled_payments_allowed_flag, :deferred_gl_account_id, :internet_query_flag, :photo, :daycare_flag, :internet_registration_flag, 
	:include_in_tax_receipt_flag, :active, :alert_text, :confirmation_text, :description, :user_stamp
	
	validates :agency_id, :brochure_section_id, :min_age, :min_age_type, :max_age, :max_age_type, :user_stamp, presence: true 
	validates :name, presence: true, length: {:maximum => 100}
	
end
