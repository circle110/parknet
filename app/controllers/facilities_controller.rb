class FacilitiesController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in
	
	
	def list
		@facilities = Facility.where(:agency_id => session[:agency_id]).order("facilities.id ASC")
	end
	
	def listMaster
		@masterFacilities = Facility.order("facilities.id ASC")
	end
	
	def show
	
	end
	
	def new	
		@facility = Facility.new
	end
	
	def create
		@facility = Facility.new(params[:facility])
		if @facility.save
			redirect_to(:action => 'list')
		else
			render('new')
		end		
	end

	def edit
		@facility = Facility.find(params[:id])
	end
	
	def update
		@facility = Facility.find(params[:id])
		if @facility.update_attributes(params[:facility])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end	
end
