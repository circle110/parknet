class AccountsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		#@accounts = Account.where(customer.head_of_household_flag = 1).order("accounts.customers.last_name, account.customers.first_name ASC")
		@accounts = Account.scoped

		if (params[:home_phone].present?)
		@accounts = @accounts.includes(:customers).where(:home_phone => params[:home_phone])
		end
		
		if (params[:last_name].present?)
		@accounts = @accounts.includes(:customers).where("customers.last_name like ?", params[:last_name])
		end

		@customers = Customer.includes(:account).where("customers.last_name = ? OR accounts.home_phone = ?", params[:last_name], params[:home_phone])

	end
	
	def new
		@account = Account.new	
	end
	
	def create
		@account = Account.new(params[:account])
		if @account.save
			@customer = Customer.new
			redirect_to(:action => 'add_head_of_household', :controller => 'customers', :account_id => @account.id)
		else
			render('new')
		end		
	end
	
	def edit
		@account = Account.find(params[:id])
	end
	
	def update
		@account = Account.find(params[:id])
		if @account.update_attributes(params[:account])
			flash[:notice] = "Account edits saved."
			redirect_to(:action => 'edit')
		else
			flash[:notice] = "Account edits failed."
			render('edit')
		end	
	end	
end
