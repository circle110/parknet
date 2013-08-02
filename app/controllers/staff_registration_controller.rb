class StaffRegistrationController < ApplicationController

	layout 'staff'

  def registration
	if params[:previous_event] == "account_selected"
		session[:account_id] = params[:id]
		@account = Customer.includes(:account).includes(:city).where("accounts.id" => params[:id])
		if params[:class_session_id]
			@program = Program.includes(:class_sessions).where("class_sessions.id" => params[:class_session_id])
			@class_sessions = ClassSessionFee.includes(:class_session).where("class_sessions.id" => params[:class_session_id])
		end
	end
	if params[:previous_event] == "program_selected"
		@class_session_id = params[:id]
		@program = Program.includes(:class_sessions).where("class_sessions.id" => params[:id])
		@class_sessions = ClassSessionFee.includes(:class_session).where("class_sessions.id" => params[:id]).order("class_session_fees.resident_type")
		if session[:account_id]
			@account = Customer.includes(:account).includes(:city).where("accounts.id" => session[:account_id])
		end
	end
  end
	
  def create_registration
	@registration = Registration.new(params[:registration])
	if @registration.save
		redirect_to(:action => 'registration', :notice => "Registration Added")
	else
		render('registration')
	end	
  end
  
  def process_registration
  end 
  
  def cart
  end
  
  def checkout
  end
  
  def take_payment
  end
  
  def lookup_account
	@accounts = Customer.includes(:account).includes(:city).where("accounts.home_phone = ? or customers.last_name = ?", params[:home_phone], params[:last_name])
	@class_session_id = params[:class_session_id]
  end
  
  def lookup_program
	@programs = ClassSession.includes(:program).where("programs.name = ? OR programs.id = ?", params[:name], params[:program_id]).collect
	@class_session_id = params[:class_session_id]
  end
  
  def show_sessions
    @programs = ClassSession.includes(:program).where("programs.id = ?", params[:program_id]).collect
	redirect_to(:action => 'lookup_program', :notice => "Select Alternate Class Session", :locals => @programs)
  end
  
end
