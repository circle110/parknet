class BrowseProgramsController < ApplicationController

	layout "browse"
	
	before_filter :check_agency
	#before_filter :wipe
	
	def browse
		agency = Agency.find(session[:agency_id])
		@program = ClassSession.where("program_id = ? AND season_id = ?", params[:id], agency.current_online_season_id)
	end
	
	
	def show
		agency = Agency.find(session[:agency_id])
		@program = ClassSession.where("program_id = ? AND season_id = ?", params[:id], agency.current_online_season_id)
	end
  
  def list
	if params[:kid]
		#kid_birthdate = DateTime.new(params["kid"]["birthdate1(1i)"].to_i, 
									#params["kid"]["birthdate1(2i)"].to_i,
									#params["kid"]["birthdate1(3i)"].to_i,)
		#kid_age = Date.today - kid_birthdate
		kid_age = 6
		@programs = Program.where("min_age < #{kid_age} and max_age > #{kid_age}")
	else
		@programs = Program.where("name like ?", "%" + params[:text] + "%")
	end
  end
  
  	def check_agency
		unless session[:agency_id]
			if params[:agency_id]
				agency_id = params[:agency_id]
				agency_id = agency_id.to_i
				session[:agency_id] = agency_id
			else
				render('no_agency')
			end
			return false # halts the before filter
		else
			return true
		end
	end
	
	def wipe
		session[:agency_id] = nil
	end
  
end
