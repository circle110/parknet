class SeasonsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@seasons = Season.order("seasons.default_registration_start_date ASC").where("agency_id = 1")
	end
	
	def show
	
	end
	
	def new	
		@season = Season.new
	end
	
	def create
		@season = Season.new(params[:season])
		if @season.save
			redirect_to(:action => 'list')
		else
			render('new')
		end		
	end
	
	def edit
		@season = Season.find(params[:id])
	end
	
	def update
		@season = Season.find(params[:id])
		if @season.update_attributes(params[:season])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end	
end
