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
		customers_in_account = Customer.where("account_id" => session[:account_id])
		customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
		credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:credit)
		debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:debit)
		@balance  = credits - debits
		@agency = Agency.find(session[:agency_id])
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
			customers_in_account = Customer.where("account_id" => session[:account_id])
			customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
			credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:credit)
			debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:debit)
			@balance  = credits - debits
			@registration = current_agency.registrations.new
			render('registration')
		else
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
			@class_sessions = ClassSession.where("class_sessions.id" => session[:class_session_id])
			@seasons = current_agency.seasons.find(:all)
			customers_in_account = Customer.where("account_id" => session[:account_id])
			customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
			credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:credit)
			debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:debit)
			@balance  = credits - debits
			flash[:notice] = "Registration Failed"
			render('registration')
		end	
	end
  
	def withdraw_registration
		if params.has_key?(:registration_id)
			registration_id = params[:registration_id]
		else
			registration_id = params[:registration][:registration_id]
		end
		@registration = Registration.find(registration_id)
		@registration.status_id = "w"
		@registration.withdraw_datetime = Time.now
		if @registration.save
			if params.has_key?(:withdrawal_fee)
				apply_withdrawal_fee
			end
			flash[:notice] = "Customer successfully withdrawn from class."
			@registration = current_agency.registrations.new
			@agency = Agency.find(session[:agency_id])
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
			@class_sessions = ClassSession.where("class_sessions.id" => session[:class_session_id])
			@seasons = current_agency.seasons.find(:all)
			customers_in_account = Customer.where("account_id" => session[:account_id])
			customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
			credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:credit)
			debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:debit)
			@balance  = credits - debits
			render('registration')
		else
			flash[:notice] = "Withdrawal Failed"
			redirect(:action => 'show', :controller => 'registrations')
		end	
	end
	
	def apply_withdrawal_fee
		#get withdrawal fee amount
		fee = AdditionalFee.find(params[:withdrawal_fee])
		fee_amount = fee.fee_amount
		# get the appropriate debit and credit gls
		fee_gl = GlAccount.find(fee.gl_account_id)
		credit_gl_account_id = fee_gl.id
		customer_account_balance_gl = GlAccount.where("agency_id = #{session[:agency_id]} AND account_type = 3 and fund_id = #{fee_gl.fund_id}")	
		debit_gl_account_id = customer_account_balance_gl.first.id
		accounting_transaction = AccountingTransaction.new(
			:agency_id => session[:agency_id],
			:reference_id => params[:registration][:registration_id],
			:reference_type => 'AdditionalFee',
			:transaction_type_id => 8, #type 8 is an additional fee
			:user_stamp => params[:registration][:user_stamp],	
			:debit_gl_account_id => debit_gl_account_id,
			:credit_gl_account_id => credit_gl_account_id,
			:customer_id => params[:registration][:customer_id],
			:debit => fee_amount,
			:credit => fee_amount
		)
		accounting_transaction.save
	end

	def lookup_account
		find_account
		render('accounts/index')
		#redirect(:action => 'index', :controller => 'accounts')
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
