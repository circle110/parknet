class MembershipLevelThreesController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in
	
	def index
		@membership_level_threes = current_agency.membership_level_threes.all
	end
	
	def new
		@membership_level_three = current_agency.membership_level_threes.new
	end
	
	def create
		@membership_level_three = current_agency.membership_level_threes.new(params[:membership_level_three])
		if @membership_level_three.save
			redirect_to(:action => 'index')
		else
			render('new')
		end	
	end
	
	def edit
		@membership_level_three = MembershipLevelThree.find(params[:id])
	end

	def update
		@membership_level_three = MembershipLevelThree.find(params[:id])
		if @membership_level_three.update_attributes(params[:membership_level_three])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end

end
