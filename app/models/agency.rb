class Agency < ActiveRecord::Base
	has_many :accounts
	has_many :account_contacts
	has_many :addresses
	has_many :brochure_sections
	has_many :brochure_subsections
	has_many :cities
	has_many :class_sessions
	has_many :class_session_fees
	has_many :customers
	has_many :facilities
	has_many :facility_bookings
	has_many :facility_types
	has_many :funds
	has_many :gl_accounts
	has_many :programs
	has_many :seasons
	has_many :season_titles
	has_many :staff_users
	has_many :staff_supervisors
	
  # attr_accessible :title, :body
end
