class Agency < ActiveRecord::Base
	has_many :accounts
	has_many :customers, through: :accounts
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
	has_many :registrations
	has_many :payments
	has_many :payment_allocations, through: :payments
	has_many :registration_baskets
	has_many :registration_basket_line_items
	has_many :refunds
	has_many :membership_level_ones
	has_many :membership_level_twos
	has_many :membership_level_threes
	has_many :memberships
	has_many :membership_terms
	has_many :membership_sales
	has_many :membership_fees
	has_many :membership_scans
	has_many :locations
	
  # attr_accessible :title, :body
end
