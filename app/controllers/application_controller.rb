class ApplicationController < ActionController::Base
  protect_from_forgery
  
    private 
  
  def confirm_logged_in
	unless session[:staff_user_id]
		flash[:notice] = "Please log in."
		redirect_to(:action => 'login')
		return false # halts the before filter
	else
		return true
	end
  end
  
end
