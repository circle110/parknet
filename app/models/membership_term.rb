class MembershipTerm < ActiveRecord::Base
	
	belongs_to :agency

	attr_accessible :agency_id, :name, :term_length, :term_units, :active, :user_stamp
	
	validates :agency_id, :name, :term_length, :term_units, :active, :user_stamp, :presence => true
	validates :term_length, :numericality => true
	
end
