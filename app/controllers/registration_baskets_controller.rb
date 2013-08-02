class RegistrationBasketsController < ApplicationController

	def list
		@registration_basket = RegistrationBasket.where(:customer_id => params[:customer_id])
	end
	
	def show
	
	end
	
	def new	
		@registration_basket = RegistrationBasket.new
	end
	
	def create
		@registration_basket = RegistrationBasket.new(params[:registration_basket])
		if @registration_basket.save
			redirect_to(:action => 'list')
		else
			render('new')
		end		
	end
	
	def edit
		@registration_basket = RegistrationBasket.find(params[:id])
	end
	
	def update
		@registration_basket = RegistrationBasket.find(params[:id])
		if @registration_basket.update_attributes(params[:registration_basket])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end	
end
