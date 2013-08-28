class ChargesController < ApplicationController

	layout 'staff'

	before_filter :confirm_logged_in

	def new
		@payment = Payment.new
		@account = Account.find(session[:account_id])
		@balance = Customer.where("account_id = ?", session[:account_id]).sum(:current_account_balance)
	end

	def create
		# Set your secret key: remember to change this to your live secret key in production
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
				:description => 'Rails Stripe customer',
				:currency    => 'usd'
			)
			rescue Stripe::CardError => e
			  fail = 1
			  flash[:error] = e.message
			  render 'create'
		end
		
		if fail != 1
			create_payment
		end	
	end

end
