class OnlineRegistrationController < ApplicationController

  	layout 'customer'
	
	before_filter :confirm_customer_logged_in

	def index
	end
	
	def show
		agency = Agency.find(session[:agency_id])
		@account = Account.find(session[:customer_account_id])
		if @account.resident_flag == "1"
			resident_type = "r"
		else
			resident_type = "n"
		end
		@program = ClassSession.includes(:class_session_fees).where("class_sessions.program_id = ? AND class_sessions.season_id = ? AND (class_session_fees.resident_type = ? OR class_session_fees.resident_type = ?)", params[:id], agency.current_online_season_id, resident_type, 'b')
		@registration_basket_line_item = current_agency.registration_basket_line_items.new
	end
	
	def create_item_in_basket	
		@registration_basket_line_item = RegistrationBasketLineItem.new(
		:agency_id => session[:agency_id],
		:registration_basket_id => session[:registration_basket_id],
		:class_session_id => params[:class_session_id],
		:customer_id => params[:customer_id],
		:fee_amount => params[:fee_amount],
		:waitlist_flag => params[:waitlist_flag]
		)
		if @registration_basket_line_item.save
			agency = Agency.find(session[:agency_id])
			@account = Account.find(session[:customer_account_id])
			if @account.resident_flag == "1"
				resident_type = "r"
			else
				resident_type = "n"
			end
			class_session = ClassSession.find(params[:class_session_id])
			program_id = class_session.program.id
			@program = ClassSession.includes(:class_session_fees).where("class_sessions.program_id = ? AND class_sessions.season_id = ? AND (class_session_fees.resident_type = ? OR class_session_fees.resident_type = ?)", program_id, agency.current_online_season_id, resident_type, 'b')
			flash[:notice] = "Registration added to basket."
			render('show')
		else
			agency = Agency.find(session[:agency_id])
			@account = Account.find(session[:customer_account_id])
			if @account.resident_flag == "1"
				resident_type = "r"
			else
				resident_type = "n"
			end
			class_session = ClassSession.find(params[:class_session_id])
			program_id = class_session.program.id
			@program = ClassSession.includes(:class_session_fees).where("class_sessions.program_id = ? AND class_sessions.season_id = ? AND (class_session_fees.resident_type = ? OR class_session_fees.resident_type = ?)", program_id, agency.current_online_season_id, resident_type, 'b')
			flash[:notice] = "Registration Failed"
			render('show')
		end
		registration_basket = RegistrationBasket.find(session[:registration_basket_id])
		registration_basket.status_id = 1
		registration_basket.save!
	end
	
	def view_basket
		@registration_basket = RegistrationBasket.find(session[:registration_basket_id])
	end
	
	def waiver
		@agency = Agency.find(session[:agency_id])
		render('waiver')
	end
	
	def checkout
		@registration_basket = RegistrationBasket.find(session[:registration_basket_id])
	end
	
	def update
		# Set your secret key: remember to change this to your live secret key in production
		Stripe.api_key = "sk_test_ACQt8VvAlXfuV6fn0lIVnWFj"

		# Get the credit card details submitted by the form
		token = params[:stripeToken]

		# Create the charge on Stripe's servers - this will charge the user's card
		fail = 0
		begin
			charge = Stripe::Charge.create(
				:amount => params[:registration_basket][:stripe_amount], # amount in cents, again
				:currency => "usd",
				:card => token,
				:description => params[:userEmail]
			)
		rescue Stripe::CardError => e
		  # The card has been declined
		  fail = 1
		  flash[:error] = e.message
		  render('show')
		end
		
		if fail != 1
			# create payment record
			@payment = current_agency.payments.new(
				:agency_id => session[:agency_id],
				:account_id => session[:customer_account_id],
				:location_id => 0,
				:payment_type_id => 3,
				:amount => params[:registration_basket][:total_fee],
				:stripe_token => token,
				:user_stamp => 0, # 0 is the system ID
				:creation_user_stamp => 0, # 0 is the system ID
				# below are the attribute accessors needed in the model
				:registration_basket_id => session[:registration_basket_id],
				:online => 'y'
			)
			@payment.save!
			
			session[:registration_basket_id] = nil
			registration_basket = RegistrationBasket.new(
				:agency_id => session[:agency_id],
				:account_id => session[:account_id],
				:status_id => 0 #0 means basket is created but has not been used yet.
			)
			registration_basket.save!
			session[:registration_basket_id] = registration_basket.id
			render('take_payment')
		end
	end
	
	def my_account
		@account = Account.find(session[:account_id])
	end
  
end
