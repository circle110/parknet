class RefundsController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in

	def new
		@account = Account.find(session[:account_id])
		customers_in_account = Customer.where("account_id" => session[:account_id])
		@balance = customers_in_account.sum(:current_account_balance)
		@withdrawals = AccountingTransaction.where("transaction_type_id = 3 AND customer_id in (?)", customers_in_account)
		@refund = current_agency.refunds.new
	end
	
	def create
		@refund = current_agency.refunds.new(params[:refund])
		if @refund.save
			flash[:notice] = "Refund Requested"
			render('create')
		else
			flash[:notice] = "Refund Request Failed"
			render('create')
		end
	end

end
