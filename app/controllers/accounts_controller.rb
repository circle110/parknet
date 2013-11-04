class AccountsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def index
		@customers = []
		@initial = "yes"
	end
	
	def new
		@account = Account.new(:agency_id => session[:agency_id])
	end
	
	def search
		find_account
		@search_text = params[:search_text]
		render('index')
	end
	
	def create
		@account = Account.new(params[:account])
		if @account.save
			@customer = Customer.new
			redirect_to(:action => 'add_head_of_household', :controller => 'customers', :account_id => @account.id)
		else
			flash[:notice] = "Account creation failed."
			render('new')
		end		
	end
	
	def edit
		@search_text = params[:search_text]
		@account = Account.find(params[:id])
		@balance = Customer.where("account_id = ?", session[:account_id]).sum(:current_account_balance)
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
