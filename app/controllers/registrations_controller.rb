class RegistrationsController < ApplicationController

	layout "staff"
	before_filter :confirm_logged_in

	def index
		customers_in_account = Customer.where("account_id = ?", params[:account_id])
		@registrations = Registration.includes(:class_session, :customer).where("customer_id in (?)", customers_in_account).order("class_sessions.season_id", "customers.last_name", "customers.first_name")
		@account = Account.find(params[:account_id])
	end

	def show
		@registrations = Registration.where("customer_id = ?", params[:id])
		@customer = Customer.find(params[:id])
	end
	
	def withdraw
		@registration = Registration.find(params[:registration_id])
		@customer = Customer.find(params[:customer_id])
	end
	
	def select_class_list
		@programs = current_agency.programs.all
		@seasons = current_agency.seasons.all
		@class_sessions = current_agency.class_sessions.all
	end
	
	def class_list
		@class_list = Registration.where("class_session_id = ? AND status_id = 'a'", params[:class_session_id])
	end
	
	def update_programs
		@programs = current_agency.programs.includes(:class_session).where("class_sessions.season_id = ?", params[:season_id]).map{|a| [a.name, a.id]}.insert(0, "--Select Program--")
	end
	
	def update_class_sessions
		@class_sessions_program = current_agency.class_sessions.where("program_id = ? AND season_id = ?", params[:program_id], params[:season_id]).map{|a| [a.session_identifier, a.id]}.insert(0, "--Select Class Session--")
	end

end
