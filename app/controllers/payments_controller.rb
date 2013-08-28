class PaymentsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def new
		@payment = current_agency.payments.new
		customers_in_account = Customer.where("account_id = ?", session[:account_id])
		@balance = Customer.where("account_id = ?", session[:account_id]).sum(:current_account_balance)
		@registrations = current_agency.registrations.where("customer_id in (?) and unpaid_balance > 0", customers_in_account)
		@registrations.count.times {@payment.payment_allocations.build}
		@account = Account.find(session[:account_id])
		session[:payment_type_id] = params[:payment_type_id]
	end
	
	def create
		@account = Account.find(session[:account_id])
		@payment = current_agency.payments.new(params[:payment])
		@payment.stripe_token = params[:stripe_token]
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
				@balance = Customer.where("account_id = ?", session[:account_id]).sum(:current_account_balance)
				@registrations = current_agency.registrations.where("customer_id in (?) and unpaid_balance > 0", customers_in_account)
				flash[:notice] = "Payment not accepted."
				render('new')
			end	
		end	
	end
	
end
