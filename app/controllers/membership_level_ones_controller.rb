class MembershipLevelOnesController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in
	
	def index
		@membership_level_ones = current_agency.membership_level_ones.order("membership_level_ones.name").collect
	end
	
	def new
		@membership_level_one = current_agency.membership_level_ones.new
	end
	
	def create
		@membership_level_one = current_agency.membership_level_ones.new(params[:membership_level_one])
		if @membership_level_one.save
			redirect_to(:action => 'index')
		else
			render('new')
		end	
	end
	
	def edit
		@membership_level_one = MembershipLevelOne.find(params[:id])
	end

	def update
		@membership_level_one = MembershipLevelOne.find(params[:id])
		if @membership_levels_one.update_attributes(params[:membership_level_one])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end

end
