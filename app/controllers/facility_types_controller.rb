class FacilityTypesController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in
	
	
	def index
		@facility_types = FacilityType.where(:agency_id => session[:agency_id])
	end
	
	def show
	
	end
	
	def new	
		@facility_type = FacilityType.new
	end
	
	def create
		@facility_type = FacilityType.new(params[:facility_type])
		if @facility_type.save
			redirect_to(:action => 'index')
		else
			render('new')
		end		
	end

	def edit
		@facility_type = FacilityType.find(params[:id])
	end
	
	def update
		@facility_type = FacilityType.find(params[:id])
		if @facility_type.update_attributes(params[:facility_type])
			redirect_to(:action => 'index')
		else
			render('edit')
		end	
	end	
end
