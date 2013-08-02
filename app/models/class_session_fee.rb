class ClassSessionFee < ActiveRecord::Base
	belongs_to :agency
	belongs_to :class_session
	has_one :staff_user

	
	attr_accessible :agency_id, :user_stamp, :amount, :name, :resident_type, :member_type, :class_session_id, :active
	
	def name_amount
		"$#{amount} -- #{name}"
	end
end
