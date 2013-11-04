class FacilityType < ActiveRecord::Base
	belongs_to :agency
	has_many :facilities

	
  attr_accessible :agency_id, :name, :active, :user_stamp
end
