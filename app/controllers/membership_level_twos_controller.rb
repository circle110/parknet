class MembershipLevelTwosController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in
	
	def index
		@membership_level_twos = current_agency.membership_level_twos.all
	end
	
	def new
		@membership_level_two = current_agency.membership_level_twos.new
	end
	
	def create
		@membership_level_two = current_agency.membership_level_twos.new(params[:membership_level_two])
		if @membership_level_two.save
			redirect_to(:action => 'index')
		else
			render('new')
		end	
	end
	
	def edit
		@membership_level_two = MembershipLevelTwo.find(params[:id])
	end

	def update
		@membership_level_two = MembershipLevelTwo.find(params[:id])
		if @membership_level_two.update_attributes(params[:membership_level_two])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end

end
