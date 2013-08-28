class CustomerAccessController < ApplicationController

  	layout 'customer_login'
	
	before_filter :confirm_customer_logged_in, :except => [:login, :attempt_login, :logout]

  def index
	menu
	render('menu')
  end
  
  def menu
	render layout: 'customer'
  end
  
  def show
  end
  
  def login
  	render layout: "customer_login"
	#render('login')
  end
  
    def logout
  		session[:customer_account_id] = nil
		session[:agency_id] = nil
		session[:email] = nil
		session[:agency_name] = nil
		session[:registration_basket_id] = nil
		flash[:notice] = "You have been logged out."
		render('login')
	end
  
  def attempt_login
	authorized_customer = Account.authenticate(params[:email], params[:password])
	if authorized_customer
		session[:customer_account_id] = authorized_customer.id
		session[:email] = authorized_customer.email
		agency_id = authorized_customer.agency_id
		session[:agency_id] = agency_id
		agency = Agency.where(:id => agency_id)
		session[:agency_name] = agency.first.name
		
		registration_basket = RegistrationBasket.new(
		:agency_id => agency_id,
		:account_id => authorized_customer.id,
		:status_id => 0 #0 means basket is created but has not been used yet.
		)
		
		registration_basket.save
		session[:registration_basket_id] = registration_basket.id
		flash[:notice] = "Welcome, #{authorized_customer.email}! You are now logged in."
		redirect_to(:action => 'menu')
	else
		flash[:notice] = "Invalid email/password combination."
		redirect_to(:action => 'login')
	end
 end
  

end
