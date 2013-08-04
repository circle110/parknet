class AccountsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@class_session_id = params[:class_session_id]
		if params[:account_id]
			@customers = Customer.includes(:account, :city).where("accounts.id = ?", params[:account_id])
		else
			search_text = params[:search_text] 
			if search_text.respond_to?(:to_str)
				last_name = search_text
			else
				last_name = ""
			end
			if search_text.match /^\d+(?:-\d+)*$/
				phone = search_text
				phone = phone.sub!(/-/, '')
				#phone = phone.sub!(/./, '')
				#phone = phone.sub!(/(/, '')
				#phone = phone.sub!(/)/, '')
			else
				phone = ""
			end
			@customers = Customer.includes(:account, :city).where("customers.agency_id = ? AND (customers.last_name = ? OR accounts.home_phone = ?)", session[:agency_id], last_name, phone)
		end
	end
	
	def new
		@account = Account.new(:agency_id => session[:agency_id])
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
