class Customer < ActiveRecord::Base
	belongs_to :agency
	belongs_to :account
	has_one :address
	has_one :staff_user
	has_one :city, through: :account
	
	attr_accessible :agency_id, :account_id, :first_name, :last_name, :head_of_household_flag, :email, :status_id, :birthdate, :head_of_household_flag, 
	:gender_id, :alert_text, :user_stamp
	
	#validates :email, :uniqueness => true
	
	def full_name
		"#{first_name} #{last_name}"
	end
	
	def full_name_last_first
		"#{last_name}, #{first_name}"
	end

	
end

