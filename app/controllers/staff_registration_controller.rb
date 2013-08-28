class StaffRegistrationController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in

	def registration	
		if params[:previous_event] == "account_selected"
			session[:account_id] = params[:id]
		end
		if params[:previous_event] == "program_selected"
			session[:class_session_id] = params[:id]
		end	
		if session[:account_id]
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
		end
		if session[:class_session_id]
			@class_sessions = ClassSession.where("class_sessions.id" => session[:class_session_id])
		end	
		@registration = current_agency.registrations.new
		@seasons = current_agency.seasons.find(:all)
		@balance = Customer.where("account_id" => session[:account_id]).sum(:current_account_balance)
	end
	
	def create_registration
		@registration = current_agency.registrations.new(
		:agency_id => params[:agency_id],
		:user_stamp => params[:user_stamp],
		:creation_user_stamp => params[:user_stamp],
		:class_session_id => params[:class_session_id],
		:customer_id => params[:customer_id],
		:fee_amount => params[:fee_amount],
		:unpaid_balance => params[:fee_amount]
		)

		if	@registration.save
			flash[:notice] = "Registration Added"
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
			@class_sessions = ClassSession.where("class_sessions.id" => session[:class_session_id])
			@seasons = current_agency.seasons.find(:all)
			@balance = Customer.where("account_id" => session[:account_id]).sum(:current_account_balance)
			@registration = current_agency.registrations.new
			render('registration')
		else
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
			@class_sessions = ClassSession.where("class_sessions.id" => session[:class_session_id])
			@seasons = current_agency.seasons.find(:all)
			@balance = Customer.where("account_id" => session[:account_id]).sum(:current_account_balance)
			flash[:notice] = "Registration Failed"
			render('registration')
		end	
	end
  
	def withdraw_registration
		@registration = Registration.find(params[:registration_id])
		@registration.status_id = "w"
		@registration.withdraw_datetime = Time.now
		@registration.user_stamp = session[:staff_user_id]
		if @registration.save
			flash[:notice] = "Customer successfully withdrawn from class."
			@registration = current_agency.registrations.new
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
			@class_sessions = ClassSession.where("class_sessions.id" => session[:class_session_id])
			@seasons = current_agency.seasons.find(:all)
			@balance = Customer.where("account_id" => session[:account_id]).sum(:current_account_balance)
			render('registration')
		else
			flash[:notice] = "Withdrawal Failed"
			redirect(:action => 'show', :controller => 'registrations')
		end	
	end

	def lookup_account
		find_account
	end

	def lookup_program
		find_program
	end
  
  	def different_session
		@programs = current_agency.class_sessions.includes(:program).where("class_sessions.season_id = ? AND programs.id = ?", params[:season_id], params[:program_id]).collect
		@seasons = Season.find(:all)
		render 'lookup_program'
	end
  
end
