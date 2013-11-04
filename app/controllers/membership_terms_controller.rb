class MembershipTermsController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in
	

	def index
		@membership_terms = current_agency.membership_terms.all
	end
	
	def new
		@membership_term = current_agency.membership_terms.new
	end
	
	def create
		@membership_term = current_agency.membership_terms.new(params[:membership_term])
		if @membership_term.save
			@membership_terms = current_agency.membership_terms.all
			render('index')
		else
			render('new')
		end
	end
	
	def edit
		@membership_term = MembershipTerm.find(params[:id])
	end
	
	def update
		@membership_term = MembershipTerm.find(params[:id])
		if @membership_term.update_attributes(params[:membership_term])
			flash[:notice] = "Membership Term Updated"
			redirect_to(:action => 'index')
		else
			flash[:notice] = "Membership Term Update Failed"
			render('edit')
		end	
	end

end
