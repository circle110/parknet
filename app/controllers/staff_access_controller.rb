class StaffAccessController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def index
	menu
	render('menu')
  end
  
  def menu
  end

  def login
  	render layout: "staff_login"
  end
  
  def attempt_login
	authorized_staff_user = StaffUser.authenticate(params[:email], params[:password])
	if authorized_staff_user
		session[:staff_user_id] = authorized_staff_user.id
		session[:email] = authorized_staff_user.email
		agency_id = authorized_staff_user.agency_id
		session[:agency_id] = agency_id
		agency = Agency.where(:id => agency_id)
		session[:agency_name] = agency.first.name
		flash[:notice] = "You are now logged in."
		redirect_to(:action => 'menu')
	else
		flash[:notice] = "Invalid email/password combination."
		redirect_to(:action => 'login')
	end
 end
  
  def logout
  		session[:staff_user_id] = nil
		session[:agency_id] = nil
		flash[:notice] = "You have been logged out."
		redirect_to(:action => 'login')
  end
  

  
end
 