class StaffSessionsController < ApplicationController
  def new
  end
  
  def create
	staff_user = StaffUser.authenticate(params[:email], params[:password])
	if staff_user
		session[:staff_user_id] = staff_user.id
		redirect_to :staff_menu, :notice => "Log in successful."
	else
		flash.now.alert = "Invalid email or password"
		render ('new')
	end
  end
end
