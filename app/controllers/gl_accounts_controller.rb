class GlAccountsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def index
		@gl_accounts = current_agency.gl_accounts.includes(:fund).order("gl_accounts.active ASC", "funds.fund ASC", "gl_account_number ASC")
	end
	
	def show
	
	end
	
	def new	
		@gl_account = current_agency.gl_accounts.new
	end

	
	def create
		@gl_account = current_agency.gl_accounts.new(params[:gl_account])
		if @gl_account.save
			redirect_to(:action => 'index')
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
			redirect_to(:action => 'index')
		else
			render('edit')
		end	
	end	
end
