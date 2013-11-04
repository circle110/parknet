class MembershipLevelThree < ActiveRecord::Base

	belongs_to :agency
	has_many :memberships
	
	attr_accessible :agency_id, :name, :multi_member, :member_quantity, :resident, :age_based, :minimum_age, :maximum_age, :active, :user_stamp
	
end
