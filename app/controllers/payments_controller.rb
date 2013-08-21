class PaymentsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def new
		@payment = current_agency.payments.new
		@customers_in_account = Customer.where("account_id = ?", session[:account_id])
		@balance = Customer.where("account_id = ?", session[:account_id]).sum(:current_account_balance)
		@registrations = current_agency.registrations.where("customer_id in (?) and unpaid_balance > 0", @customers_in_account)
		@registrations.count.times {@payment.payment_allocations.build}
		@account = Account.find(session[:account_id])
	end
	
	def create
		@payment = current_agency.payments.new(params[:payment])
		#@customers_in_account = Customer.where("account_id = ?", session[:account_id])
		#@balance = Customer.where("account_id = ?", session[:account_id]).sum(:current_account_balance)
		#@registrations = current_agency.registrations.where("customer_id in (?) and unpaid_balance > 0", @customers_in_account)
		#@registrations.count.times {@payment.payment_allocations.build}
		#@account = Account.find(session[:account_id])
		if @payment.save
			flash[:notice] = "Payment of #{params[:amount]} made on account"
			redirect_to(:action => 'registration', :controller => 'staff_registration', :notice => "Payment of #{params[:amount]} made on account", :locals => {:previous_event => 'payment_taken'})
		else 
			flash[:notice] = "Payment not accepted."
			render('failed')
			#redirect_to(:action => 'registration', :controller => 'staff_registration', :notice => "Payment of #{params[:amount]} NOT made on account", :locals => {:previous_event => 'payment_taken'})
		end	
	end
	
	def failed
	
	end
end
