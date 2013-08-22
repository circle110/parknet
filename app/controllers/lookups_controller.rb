class LookupsController < ApplicationController
  protect_from_forgery
  
	def lookup_account
		search_text = params[:search_text] 
		if search_text.respond_to?(:to_str)
			last_name = search_text
		else
			last_name = ""
		end
		if search_text.match /^\d+(?:-\d+)*$/
			phone = search_text
			phone = phone.sub!(/-/, '')
			#phone = phone.sub!(/./, '')
			#phone = phone.sub!(/(/, '')
			#phone = phone.sub!(/)/, '')
		else
			phone = ""
		end
		@accounts = current_agenct_customers.includes(:account).includes(:city).where("accounts.home_phone = ? or customers.last_name like ?", phone, "%#{last_name}%").order("last_name", "first_name")
		@class_session_id = params[:class_session_id]
	end


	def list
		#@class_session_id = params[:class_session_id]
		if params[:account_id]
			@customers = Customer.includes(:account).where("accounts.id = ?", params[:account_id])
		else
			search_text = params[:search_text] 
			if search_text.respond_to?(:to_str)
				last_name = search_text
			else
				last_name = ""
			end
			if search_text.match /^\d+(?:-\d+)*$/
				phone = search_text
				phone = phone.sub!(/-/, '')
				#phone = phone.sub!(/./, '')
				#phone = phone.sub!(/(/, '')
				#phone = phone.sub!(/)/, '')
			else
				phone = ""
			end
			@customers = Customer.includes(:account).where("customers.agency_id = ? AND (customers.last_name = ? OR accounts.home_phone = ?)", session[:agency_id], last_name, phone)
		end
	end  
  
  	def find_program
		search_text = params[:search_text]
		@programs = current_agency.class_sessions.includes(:program, :class_session_fees).where("class_sessions.season_id = ? AND (programs.name like ? OR programs.code = ? OR programs.id = ?)", params[:season_id], "%#{search_text}%", search_text, params[:program_id]).collect
		@seasons = Season.find(:all)
	end
  
  

  
end