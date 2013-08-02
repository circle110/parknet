class ClassSessionsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@class_sessions = ClassSession.order("class_sessions.program_id, class_sessions.session_display_order ASC")
	end
	
	def show
	
	end
	
	def new	
		@class_session = ClassSession.new(:program_id => params[:program_id], :agency_id => params[:agency_id])
		#@seasons = Season.order("seasons.id ASC")
	end
	
	def create
		@class_session = ClassSession.new(params[:class_session])
		if @class_session.save
			redirect_to(:action => 'edit', :controller => 'programs', :id => params[:program_id])
		else
			render('new')
		end		
	end
	
	def full_name_last_first
		@staff_user = StaffUser.new
		@staff_user.last_name + "' " + @staff_user.first_name
	end

	def edit
		@class_session = ClassSession.find(params[:id])
		@fees = ClassSessionFee.includes(:class_session).where("class_sessions.id = ?", params[:id])
	end
	
	def update
		@program = Program.find(params[:class_session][:program_id])
		@class_session = ClassSession.find(params[:id])
		if @class_session.update_attributes(params[:class_session])
			flash[:notice] = "Class session edits saved."
			redirect_to(:action => 'edit', :controller => 'programs', :id => params[:class_session][:program_id])
		else
			render('edit')
		end	
	end	
	

end