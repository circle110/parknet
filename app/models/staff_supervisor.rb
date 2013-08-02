class StaffSupervisor < ActiveRecord::Base
	belongs_to :agency
	has_one :staff_user
	
  # attr_accessible :title, :body
end
