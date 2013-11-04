class StaffUserRole < ActiveRecord::Base

	belongs_to :agency
	has_and_belongs_to_many :staff_users
	
	attr_accessible :agency_id, :staff_user_id, :name, :user_stamp
	

end
