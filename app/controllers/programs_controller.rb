class ProgramsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@agency = Agency.find(session[:agency_id])
		@programs = Program.where("agency_id = #{session[:agency_id]}").order("programs.id ASC")
	end
	
	def show
		@program = Program.find(params[:id])
	end
	
	def browse
		@program = Program.find(params[:id])
	end
	
	def new	
		@program = Program.new
	end
	
	def create
		@program = Program.new(params[:program])
		if @program.save
			redirect_to(:action => 'list')
		else
			flash[:notice] = "Program creation failed"
			render('new')

		end		
	end

	def edit
		@program = Program.find(params[:id])
		@agency_id = session[:agency_id]
		@this_season = params[:season_id]
		@seasons = Season.find(:all,
							:joins => [:season_title],
							:order => 'seasons.default_registration_start_date ASC')
	end
	
	
	def update
		@program = Program.find(params[:id])
		@seasons = Season.find(:all,
							:joins => [:season_title],
							:order => 'seasons.default_registration_start_date ASC')
		if @program.update_attributes(params[:program])
			flash[:notice] = "Program edits saved."
			redirect_to(:action => 'edit', :id => params[:id])
		else
			flash[:notice] = "Program edits failed."
			render('edit')
		end	
	end	
end
