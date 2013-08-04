class StaffRegistrationController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in

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
	@registration = Registration.new
  end
  
  	def update_account_balance
		account = Account.find(params[:account_id])
		amount = params[:fee_amount]
		account.current_balance += amount.to_f
		account.save
	end

	def update_class_num_registered
		class_session = ClassSession.find(params[:class_session_id])
		class_session.number_registered = class_session.number_registered + 1
		if params[:waitlist_flag] == 1
			class_session.number_waitlisted = class_session.number_waitlisted + 1
		end
		class_session.save
	end
	
	def update_accounting_transactions_registration
		@class_session = ClassSession.find(params[:class_session_id])
		# set debit gl to AR account - NEED TO DEAL ON THIS!!!
		debit_gl_account_id = 9
		if @class_session.start_date > Date.today  # set credit gl to deferred gl if the class starts in the future
			credit_gl_account_id = @class_session.deferred_gl_account_id
		else  # set credit gl to program revenue if the class has already started
			credit_gl_account_id = @class_session.gl_account_id
		end
		accounting_transaction = AccountingTransaction.new(
			:agency_id => params[:agency_id],
			:user_stamp => params[:user_stamp],	
			:debit_gl_account_id => debit_gl_account_id,
			:credit_gl_account_id => credit_gl_account_id,
			:customer_account_id => params[:account_id],
			:debit => params[:fee_amount],
			:credit => params[:fee_amount]
		)
		accounting_transaction.save
	end
	
  def create_registration
	@registration = Registration.new(
	:agency_id => params[:agency_id],
	:user_stamp => params[:user_stamp],
	:creation_user_stamp => params[:user_stamp],
	:class_session_id => params[:class_session_id],
	:customer_id => params[:customer_id],
	:fee_amount => params[:fee_amount]
	)
	@account = Customer.includes(:account).includes(:city).where("accounts.id" => params[:account_id])
	@program = Program.includes(:class_sessions).where("class_sessions.id" => params[:class_session_id])
	@class_sessions = ClassSessionFee.includes(:class_session).where("class_sessions.id" => params[:class_session_id])
	if @registration.save
		update_accounting_transactions_registration
		update_account_balance
		update_class_num_registered
		flash[:notice] = "Registration Added"
		@registration = Registration.new
		render('registration')
	else
		flash[:notice] = "Registration Failed"
		render('registration')
	end	
  end
 
  
  def cart
  end
  
  def checkout
  end
  
  def take_payment
  end
  
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
	@accounts = Customer.includes(:account).includes(:city).where("accounts.home_phone = ? or customers.last_name = ?", phone, last_name)
	@class_session_id = params[:class_session_id]
  end
  
  def lookup_program
  	search_text = params[:search_text]
	@programs = ClassSession.includes(:program, :class_session_fees).where("programs.name = ? OR programs.code = ? OR programs.id = ?", search_text, search_text, params[:program_id]).collect
	@class_session_id = params[:class_session_id]
  end
  
  def show_sessions
    @programs = ClassSession.includes(:program).where("programs.id = ?", params[:program_id]).collect
	redirect_to(:action => 'lookup_program', :notice => "Select Alternate Class Session", :locals => @programs)
  end
  
end
