class AccountingTransactionsController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in

	def show_account_history
		customers_in_account = Customer.where("account_id = ?", session[:account_id])
		@history = AccountingTransaction.
		  select([:reference_id, :transaction_type_id, :created_at]).
		  select(AccountingTransaction.arel_table[:credit].sum.as("credit_sum")).
		  where("customer_id in (?) AND no_download <> 1", customers_in_account).
		  group(:transaction_type_id, :reference_id).
		  order(:created_at)
  
		@account = Account.find(session[:account_id])
	end
	
	# def select_date_gl_report
	
	# end
	
	def daily_gl_report
		@report_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
		@one_day_later = @report_date + 1
		  
		  debit_gls = AccountingTransaction.select(:debit_gl_account_id).where("created_at >= ? AND created_at < ?", @report_date, @one_day_later)
		  credit_gls = AccountingTransaction.select(:credit_gl_account_id).where("created_at >= ? AND created_at < ?", @report_date, @one_day_later)
		  debits = []
		  credits = []
		  debit_gls.each do |d|
			debits << d.debit_gl_account_id
		  end
		  
		  credit_gls.each do |c|
			credits << c.credit_gl_account_id
		  end
		  
		  @all_gls = debits |= credits
		  @gl_info = []
		  @all_gls.each do |g|
			gl_info = GlAccount.find(g)
			myHash = {}
			myHash[:gl_id] = gl_info.id
			myHash[:fund_id] = gl_info.fund_id
			myHash[:gl_account_number] = gl_info.gl_account_number
			myHash[:name] = gl_info.name
			@gl_info << myHash 
		  end
		  
		  @gl_info.sort_by! { |hsh| hsh[:fund_id] }
		  
	end

end
