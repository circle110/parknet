class CustomersController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@customers = Customer.order("customer.last_name, customer.first_name ASC")
	end
	
	def new	
		@customer = Customer.new
	end
	
	def create
		@customer = Customer.new(params[:customer])
		if @customer.save
			redirect_to(:action => 'list', :notice => "New Customer Added")
		else
			render('new')
		end		
	end
	
	def add_head_of_household
		@customer = Customer.new
	end
	
	
	def add_member
		@customer = Customer.new(params[:customer])
		if @customer.save
			@account = Customer.includes(:account).where("accounts.id = ?", @customer.account_id)
			#redirect_to(:action => 'add_member', :notice => "New Account member Added", :account_id => @customer.account_id, :account => @account)
		else
			flash[:notice] = "Failed to add new account member"
			render('add_member')
		end	
	end
	
	def edit
		@customer = Customer.find(params[:id])
	end
	
	def update
		@customer = Customer.find(params[:id])
		if @customer.update_attributes(params[:customer])
			redirect_to(:action => 'edit', :controller => 'accounts', :id => @customer.account_id)
		else
			render('edit')
		end	
	end	
	
	
end
