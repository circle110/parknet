class BrochureSection < ActiveRecord::Base
	belongs_to :agency
	has_many :brochure_subsections
	has_many :programs
	has_many :class_sessions, :through => :programs
	
	validates :name, :agency_id, :user_stamp, presence: true
	
	attr_accessible :agency_id, :name, :active, :description, :user_stamp
end
