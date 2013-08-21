class BrochureSubsection < ActiveRecord::Base
	belongs_to :agency
	belongs_to :brochure_section
	has_many :programs
	
	attr_accessible :agency_id, :brochure_section_id, :name, :active, :description, :user_stamp
	
	validates :agency_id, :brochure_section_id, :name, :active, :user_stamp, :presence => true
end
