class RegistrationsController < ApplicationController

	layout "staff"
	before_filter :confirm_logged_in

def show
	@registrations = Registration.where("customer_id = ?", params[:id])
	@customer = Customer.find(params[:id])
end

end
