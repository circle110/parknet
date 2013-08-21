class ChargesController < ApplicationController

	layout 'staff'

	before_filter :confirm_logged_in

	def new
		@payment = Payment.new
		@account = Account.find(session[:account_id])
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
			  flash[:error] = e.message
			  fail = 1
			  render 'create'
		end
		
		if fail != 1
			create_payment
		end
		
	end
	
	def create_payment
		@payment = Payment.new(params[:payment])
		@payment.stripe_token = params[:stripe_token]
		if @payment.save 
			#update account balance
			@account = Account.find(params[:payment][:account_id])
			@account.current_balance = @account.current_balance - @payment.amount
			@account.save
			#update accounting transactions
			# set debit gl to credit card account
			cc_account = current_agency.gl_acounts.where("account_type = 7") #7 is the credit card account account_type
			debit_gl_account_id = cc_account.id
			# set credit gl to customer account balances account
			customer_account_balance_gl = current_agency.gl_accounts.where("gl_accounts.account_type = 3") #3 is the customer account balances account_type 
			credit_gl_account_id = customer_account_balance_gl.id
			reference_id = @payment.id
			@accounting_transaction = AccountingTransaction.new(
			:agency_id => params[:payment][:agency_id],
			:reference_id => reference_id,
			:transaction_type_id => 2, #type 2 is a payment	
			:user_stamp => params[:payment][:user_stamp],	
			:debit_gl_account_id => debit_gl_account_id,
			:credit_gl_account_id => credit_gl_account_id,
			:customer_account_id => params[:payment][:account_id],
			:debit => params[:payment][:amount],
			:credit => params[:payment][:amount]
			)
			@accounting_transaction.save
			flash[:notice] = "Payment taken for $#{@amount/100}."
			redirect_to(:action => 'registration', :controller => 'staff_registration', :notice => "Payment of #{@payment.amount} made on account", :locals => {:previous_event => 'payment_taken'})
	  
		else
			flash[:notice] = "Payment record not created."
			render('new')
		end
	end

end
