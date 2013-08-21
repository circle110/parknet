class FundsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@funds = current_agency.funds.order("funds.fund ASC")
	end
	
	def edit
		@fund = Fund.find(params[:id])
	end
	
	def new	
		@fund = current_agency.funds.new
		5.times {@fund.gl_accounts.build}
	end
	
	def create
		@fund = current_agency.funds.new(params[:fund])
		if @fund.save		
			redirect_to(:action => 'list')
		else
			render('new')
		end		
	end
	
	def update
		@fund = Fund.find(params[:id])
		if @fund.update_attributes(params[:fund])
			redirect_to(:action => 'list')
		else
			
			render('edit')
		end		
	end
	
end
