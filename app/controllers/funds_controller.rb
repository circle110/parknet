class FundsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@funds = Fund.order("funds.id ASC")
	end
	
	def edit
		@fund = Fund.find(params[:id])
	end
	
	def new	
		@fund = Fund.new
	end
	
	def create
		@fund = Fund.new(params[:fund])
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