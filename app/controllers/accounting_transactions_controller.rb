class AccountingTransactionsController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in

	def show_account_history
		@customers_in_account = Customer.where("account_id = ?", params[:account_id])
		@history = AccountingTransaction.where("customer_account_id in (?)", @customers_in_account).order(:created_at)
		@account = Account.find(params[:account_id])
	end

end
