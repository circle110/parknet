class GlAccountsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@gl_accounts = GlAccount.order("gl_accounts.gl_account_number ASC")
	end
	
	def show
	
	end
	
	def new	
		@gl_account = GlAccount.new
	end

	
	def create
		@gl_account = GlAccount.new(params[:gl_account])
		if @gl_account.save
			redirect_to(:action => 'list')
		else
			render('new')
		end		
	end
	
	def edit
		@gl_account = GlAccount.find(params[:id])
	end
	
	def update
		@gl_account = GlAccount.find(params[:id])
		if @gl_account.update_attributes(params[:gl_account])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end	
end