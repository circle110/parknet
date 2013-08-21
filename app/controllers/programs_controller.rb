class ProgramsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@programs = current_agency.programs.find(:all)
	end
	
	def show
		@program = Program.find(params[:id])
	end
	
	def browse
		@program = Program.find(params[:id])
	end
	
	def new	
		@program = current_agency.programs.new
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
		if params[:season_id] 
			season_id = params[:season_id]
		else
			#season_id = session[:current_working_season] -- Got to deal on this
			season_id = 1
		end
		@program = Program.find(params[:id])
		@class_sessions = ClassSession.where("program_id = ? and season_id = ?", params[:id], season_id)
		@season_id = season_id
		@seasons = current_agency.seasons.find(:all,
							:joins => [:season_title],
							:order => 'seasons.default_registration_start_date ASC')
		@this_season = Season.find(season_id)
	end
	
	
	def update
		@program = Program.find(params[:id])
		@seasons = current_agency.seasons.find(:all,
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
