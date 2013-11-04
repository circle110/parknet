class HeadshotsController < ApplicationController
	
	helper :headshot
	
	layout "staff"
	
	before_filter :confirm_logged_in
	
	def headshot_post_save
		@customer = current_agency.customers.find(params[:id])
		@customer.headshot_photo = params[:photo]
		if @customer.update_attributes(params[:customer])
			redirect_to(:action => 'edit', :controller => 'accounts', :id => @customer.account_id)
		else
			render('edit')
		end	
	end
	
	def index
		@customer = current_agency.customers.find(params[:id])
	end
end