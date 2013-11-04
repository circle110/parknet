class Ability
  include CanCan::Ability
  
  
	def initialize(user)
		#user ||= StaffUser.new # guest user (not logged in)
		
		if user.has_role? :super_admin
		can :manage, :all
		else
		can :read, :all
		end
	end
	

 end
  
