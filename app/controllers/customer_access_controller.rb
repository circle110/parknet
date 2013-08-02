class CustomerAccessController < ApplicationController

  	layout 'customer'
	
	before_filter :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def index
	menu
	render('menu')
  end
  
  def menu
  end
  
  def login
  	render layout: "customer_login"
  end
  
  def attempt_login
	authorized_customer = Account.authenticate(params[:email], params[:password])
	if authorized_customer
		session[:account_id] = authorized_customer.id
		session[:email] = authorized_customer.email
		agency_id = authorized_customer.agency_id
		session[:agency_id] = agency_id
		agency = Agency.where(:id => agency_id)
		session[:agency_name] = agency.first.name
		flash[:notice] = "Welcome, #{authorized_customer.email}! You are now logged in."
		redirect_to(:action => 'browse')
	else
		flash[:notice] = "Invalid email/password combination."
		redirect_to(:action => 'login')
	end
 end
  
  def logout
  		session[:account_id] = nil
		session[:agency_id] = nil
		flash[:notice] = "You have been logged out."
		redirect_to(:action => 'login')
  end
end
