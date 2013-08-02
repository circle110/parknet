class StaffUsersController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@staff_users = StaffUser.order("staff_users.last_name, staff_users.first_name ASC")
	end
	
	def show
	
	end
	
	def new	
		@staff_user = StaffUser.new
	end
	
	def create
		@staff_user = StaffUser.new(params[:staff_user])
		if @staff_user.save
			redirect_to(:action => 'list', :notice => "New Staff User Added")
		else
			render('new')
		end		
	end
	
	def full_name_last_first
		@staff_user = StaffUser.new
		@staff_user.last_name + "' " + @staff_user.first_name
	end
	
	def edit
		@staff_user = StaffUser.find(params[:id])
	end
	
	def update
		@staff_user = StaffUser.find(params[:id])
		if @staff_user.update_attributes(params[:staff_user])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end	
end
