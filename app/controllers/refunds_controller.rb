class RefundsController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in

	def new
		@account = Account.find(session[:account_id])
		customers_in_account = Customer.where("account_id" => session[:account_id])
		customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
		credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:credit)
		debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:debit)
		@balance  = credits - debits
		@withdrawals = Registration.where("status_id = 'w' AND customer_id in (?) AND amount_refunded < fee_amount", customers_in_account)
		@refund = current_agency.refunds.new
	end
	
	def create
		@refund = current_agency.refunds.new(params[:refund])
		if @refund.save
			flash[:notice] = "Refund Requested"
			redirect_to(:action => 'registration', :controller => 'staff_registration')
		else
			flash[:notice] = "Refund Request Failed"
			render('new')
		end
	end
	
	def unrequest
		@refund = Refund.find(params[:id])
		@refund.status_id = 0
		if @refund.save
			flash[:notice] = "Refund Unrequested"
			redirect_to(:action => 'registration', :controller => 'staff_registration')
		else
			flash[:notice] = "Request to Unrefund Failed"
			render('new')
		end
	end
	
	def process_refunds
		@refund = Refund.new
		@requested = current_agency.refunds.where("status_id = 1")
		params[:process_refund] = true
	end
	
	def refunds_processed
		refunds = params[:refunds]
		#@refunds_processed = []
		refunds.each do |r|
			#@refunds_processed << r.id
			this_refund = Refund.find(r)
			this_refund.status_id = 2
			this_refund.save
		end
		redirect_to(:action => 'process_refunds')
	end

end
