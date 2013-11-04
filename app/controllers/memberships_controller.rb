class MembershipsController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in

	def index 
		@memberships = current_agency.memberships.includes(:membership_level_one, :membership_level_two, :membership_level_three).order("membership_level_ones.name", "membership_level_twos.name", "membership_level_threes.name").all
		@level_ones = current_agency.membership_level_ones.all
	end
	
	def new
		@membership = current_agency.memberships.new
		3.times do
			fee = @membership.membership_fees.build
		end
	end
	
	def create
		@membership = current_agency.memberships.new(params[:membership])
		membership_level_one = MembershipLevelOne.find(params[:membership][:membership_level_one_id])
		membership_level_two = MembershipLevelTwo.find(params[:membership][:membership_level_two_id])
		membership_level_three = MembershipLevelThree.find(params[:membership][:membership_level_three_id])
		membership_term = MembershipTerm.find(params[:membership][:membership_term_id])
		@membership.name = membership_level_one.name + " " + membership_level_two.name + " " + membership_level_three.name + " " + membership_term.name
		if @membership.save
			@memberships = current_agency.memberships.all
			render('index')
		else
			render('new')
		end
	end
	
	def edit
		@membership = current_agency.memberships.find(params[:id])
	end
	
	def update
		@membership = current_agency.memberships.new(params[:membership])
		if @membership.save
			@memberships = current_agency.memberships.includes(:membership_level_one, :membership_level_two, :membership_level_three).order("membership_level_ones.name", "membership_level_twos.name", "membership_level_threes.name").all
			flash[:notice] = "Membership updates saved."
			render('index')
		else
			flash[:notice] = "Membership updates could not be saved."
			render('edit')
		end
	end

end
