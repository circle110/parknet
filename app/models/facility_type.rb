class FacilityType < ActiveRecord::Base
	belongs_to :agency
	has_many :facilities

	
  # attr_accessible :title, :body
end
