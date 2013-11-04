class PaymentsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def new
		@payment = current_agency.payments.new
		customers_in_account = Customer.where("account_id = ?", session[:account_id])
		@customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3").select(:id)
		@customer_account_balance_funds = current_agency.gl_accounts.where("account_type = 3").select([:id, :fund_id])
		@credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, @customer_account_balance_gls).group("credit_gl_account_id").sum(:credit)
		@debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, @customer_account_balance_gls).group("debit_gl_account_id").sum(:debit)
		@registrations = current_agency.registrations.where("customer_id in (?) and unpaid_balance > 0", customers_in_account)
		@new_registration_fees = @registrations.sum(:fee_amount)
		@memberships = MembershipSale.where("customer_id in (?) and unpaid_balance > 0", customers_in_account)
		@new_membership_fees = @memberships.sum(:fee_amount)
		builder_number = @registrations.count + @memberships.count
		builder_number.times {@payment.payment_allocations.build}
		@account = Account.find(session[:account_id])
		session[:payment_type_id] = params[:payment_type_id]
	end
	
	def create
		@account = Account.find(session[:account_id])
		@payment = current_agency.payments.new(params[:payment])
		@payment.last_4 = params[:last_4]
		if @payment.payment_type_id.to_i == 3 # if it is a charge, do the Stripe routine
			# Set your secret key: remember to change this to the live secret key in production
			Stripe.api_key = "sk_test_ACQt8VvAlXfuV6fn0lIVnWFj"

			# Get the credit card details submitted by the form
			token = params[:stripe_token]
			# Amount in cents
			@amount = params[:payment][:amount]
			@amount = @amount.to_f*100
			@amount = @amount.to_i
			#customer = Stripe::Customer.create(
				#:email => 'example@stripe.com',
				#:card  => params[:stripeToken]
			#)
			begin
				charge = Stripe::Charge.create(
					:amount      => @amount,
					:card		 => token,
					:description => "#{@account.email}",
					:currency    => 'usd'
				)
			@payment.stripe_charge_id = charge.id
			rescue Stripe::CardError => e
				customers_in_account = Customer.where("account_id = ?", session[:account_id])
				@balance = Customer.where("account_id = ?", session[:account_id]).sum(:current_account_balance)
				@registrations = current_agency.registrations.where("customer_id in (?) and unpaid_balance > 0", customers_in_account)
				fail = 1
				flash[:error] = e.message
				render 'new'
			end
		end
		if fail != 1	
			if @payment.save
				flash[:notice] = "Payment of #{params[:amount]} made on account"
				redirect_to(:action => 'registration', :controller => 'staff_registration', :notice => "Payment of #{params[:amount]} made on account", :locals => {:previous_event => 'payment_taken'})
			else 
				customers_in_account = Customer.where("account_id = ?", session[:account_id])
				@customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
				@customer_account_balance_funds = current_agency.gl_accounts.where("account_type = 3").select([:id, :fund_id])
				@credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, @customer_account_balance_gls).group("credit_gl_account_id").sum(:credit)
				@debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, @customer_account_balance_gls).group("debit_gl_account_id").sum(:debit)
				@registrations = current_agency.registrations.where("customer_id in (?) and unpaid_balance > 0", customers_in_account)
				@new_registration_fees = @registrations.sum(:fee_amount)
				@account = Account.find(session[:account_id])
				customers_in_account = Customer.where("account_id = ?", session[:account_id])
				flash[:notice] = "Payment not accepted."
				render('new')
			end	
		end	
	end
	
	def daily_cash_balance_report
		@report_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
		@one_day_later = @report_date + 1
		@payments = current_agency.payments.where("created_at >= ? AND created_at < ?", @report_date, @one_day_later)
		@cash = current_agency.payments.where("created_at >= ? AND created_at < ? AND payment_type_id = 1", @report_date, @one_day_later)
		@checks = current_agency.payments.where("created_at >= ? AND created_at < ? AND payment_type_id = 2", @report_date, @one_day_later)
		@credit_cards = current_agency.payments.where("created_at >= ? AND created_at < ? AND payment_type_id = 3", @report_date, @one_day_later)
	end
	
end
