class RegistrationBasketLineItemsController < ApplicationController

	def list
		@registration_basket_line_item = RegistrationBasketLineItem.where(registration_basket_id => params[:registration_basket_id])
	end
	
	def show
	
	end
	
	def new	
		@registration_basket_line_item = RegistrationBasketLineItem.new
	end
	
	def create
		@registration_basket_line_item = RegistrationBasketLineItem.new(params[:staff_user])
		if @registration_basket_line_item.save
			redirect_to(:action => 'list')
		else
			render('new')
		end		
	end
	
	def edit
		@registration_basket_line_item = RegistrationBasketLineItem.find(params[:id])
	end
	
	def update
		@registration_basket_line_item = RegistrationBasketLineItem.find(params[:id])
		if @registration_basket_line_item.update_attributes(params[:registration_basket_line_item_id])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end	
end
