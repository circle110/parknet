class StaffMembershipSalesController < ApplicationController

	layout 'staff'
	
	before_filter :confirm_logged_in
	
	def show
		@memberships = MembershipSale.where("customer_id = ?", params[:id])
		@customer = Customer.find(params[:id])
	end

	def memberships	
		if params[:previous_event] == "account_selected"
			session[:account_id] = params[:id]
		end
		if session[:account_id]
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
		end
		if session[:class_session_id]
			@class_sessions = ClassSession.where("class_sessions.id" => session[:class_session_id])
		end	
		@staff_membership_sale = current_agency.membership_sales.new
		@level_one = current_agency.membership_level_ones.all
		@level_two = current_agency.membership_level_twos.all
		@level_three = current_agency.membership_level_threes.all
		@terms = current_agency.membership_terms.all
		@fees = current_agency.membership_fees.all
		customers_in_account = Customer.where("account_id" => session[:account_id])
		customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
		credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:credit)
		debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:debit)
		@balance  = credits - debits
		@agency = Agency.find(session[:agency_id])
		authorize! :memberships, @staff_membership_sale
	end
	
	def update_level_two
		# updates level two and level three based on level one selected
		level_two_ids = Membership.where("membership_level_one_id = ?", params[:level_one_id]).select("membership_level_two_id").map(&:membership_level_two_id)
		level_three_ids = Membership.where("membership_level_one_id = ?", params[:level_one_id]).select("membership_level_three_id").map(&:membership_level_three_id)
		term_ids = Membership.where("membership_level_one_id = ?", params[:level_one_id]).select("membership_term_id").map(&:membership_term_id)
		mem_fee_ids = Membership.where("membership_level_one_id = ?", params[:level_one_id]).select("id").map(&:id)
		@level_two = MembershipLevelTwo.where("id in (?)", level_two_ids).map{|a| [a.name, a.id]}.insert(0, "--Select Level Two--")
		@level_three = MembershipLevelThree.where("id in (?)", level_three_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Level Three--")
		@terms = MembershipTerm.where("id in (?)", term_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Term Length--")
		@fees = MembershipFee.where("membership_id in (?)", mem_fee_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Fee--")
    end
 

	def update_level_three
		# updates level three based on level two selected
		level_three_ids = Membership.where("membership_level_two_id = ? AND membership_level_one_id = ?", params[:level_two_id], params[:level_one_id]).select("membership_level_three_id").map(&:membership_level_three_id)
		term_ids = Membership.where("membership_level_one_id = ? AND membership_level_two_id = ?", params[:level_one_id], params[:level_two_id]).select("membership_term_id").map(&:membership_term_id)
		mem_fee_ids = Membership.where("membership_level_one_id = ? AND membership_level_two_id = ?", params[:level_one_id], params[:level_two_id]).select("id").map(&:id)
		@level_three = MembershipLevelThree.where("id in (?)", level_three_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Level Three--")
		@terms = MembershipTerm.where("id in (?)", term_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Term Length--")
		@fees = MembershipFee.where("membership_id in (?)", mem_fee_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Fee--")
	end
	
	def update_term
		# updates terms based on level three selected
		term_ids = Membership.where("membership_level_one_id = ? AND membership_level_two_id = ? AND membership_level_three_id = ?", params[:level_one_id], params[:level_two_id], params[:level_three_id]).select("membership_term_id").map(&:membership_term_id)
		mem_fee_ids = Membership.where("membership_level_one_id = ? AND membership_level_two_id = ? AND membership_level_three_id = ?", params[:level_one_id], params[:level_two_id], params[:level_three_id]).select("id").map(&:id)
		@terms = MembershipTerm.where("id in (?)", term_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Term Length--")
		@fees = MembershipFee.where("membership_id in (?)", mem_fee_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Fee--")	
	end
	
	def update_fees
		# updates fees based on term selected
		mem_fee_ids = Membership.where("membership_level_one_id = ? AND membership_level_two_id = ? AND membership_level_three_id = ? AND membership_term_id = ?", params[:level_one_id], params[:level_two_id], params[:level_three_id], params[:term_id]).select("id").map(&:id)
		@fees = MembershipFee.where("membership_id in (?)", mem_fee_ids).map{|s| [s.name, s.id]}.insert(0, "--Select Fee--")	
	end
	
	def create_membership_sale
		membership = current_agency.memberships.where("membership_level_one_id = ? AND membership_level_two_id = ? AND membership_level_three_id = ? AND membership_term_id = ?", params[:membership_level_one_id], params[:membership_level_two_id], params[:membership_level_three_id], params[:membership_term_id])
		membership_id = membership.first.id
		term = current_agency.membership_terms.find(params[:membership_term_id])
		fee = current_agency.membership_fees.find(params[:fee_id])
		fee_amount = fee.amount
		term_length = term.term_length
		term_unit = term.term_units
		sale = params[:date]
		start_date = Date.new sale["year"].to_i, sale["month"].to_i, sale["day"].to_i
		start_date_db = sale["year"] + "-" + sale["month"] + "-" + sale["day"]
		case term_unit
			when "w"
				expiry_date = start_date + term_length.weeks
			when "m"
				expiry_date = start_date + term_length.months
			when "y"
				expiry_date = start_date + term_length.years
		end
		@membership_sale = current_agency.membership_sales.new(
		:agency_id => params[:agency_id],
		:location => params[:location_id],
		:membership_id => membership_id,
		:customer_id => params[:customer_id],
		:fee_amount => fee_amount,
		:membership_fee_id => params[:fee_id],
		:subscription_flag => membership.first.subscription_flag,
		:start_date => start_date_db,
		:expiry_date => expiry_date.to_s,
		:user_stamp => session[:staff_user_id],
		:creation_user_stamp => session[:staff_user_id]
		)

		if	@membership_sale.save
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
			@staff_membership_sale = current_agency.membership_sales.new
			@level_one = current_agency.membership_level_ones.all
			@level_two = current_agency.membership_level_twos.all
			@level_three = current_agency.membership_level_threes.all
			@terms = current_agency.membership_terms.all
			@fees = current_agency.membership_fees.all
			customers_in_account = Customer.where("account_id" => session[:account_id])
			customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
			credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:credit)
			debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:debit)
			@balance  = credits - debits
			@agency = Agency.find(session[:agency_id])
			flash[:notice] = "Membership Sold"
			render('memberships')
		else
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
			@staff_membership_sale = current_agency.membership_sales.new
			@level_one = current_agency.membership_level_ones.all
			@level_two = current_agency.membership_level_twos.all
			@level_three = current_agency.membership_level_threes.all
			@terms = current_agency.membership_terms.all
			@fees = current_agency.membership_fees.all
			customers_in_account = Customer.where("account_id" => session[:account_id])
			customer_account_balance_gls = current_agency.gl_accounts.where("account_type = 3")
			credits = AccountingTransaction.where("customer_id in (?) AND credit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:credit)
			debits = AccountingTransaction.where("customer_id in (?) AND debit_gl_account_id in (?)", customers_in_account, customer_account_balance_gls).sum(:debit)
			@balance  = credits - debits
			@agency = Agency.find(session[:agency_id])
			flash[:notice] = "Membership Sale Failed"
			render('memberships')
		end	
	end
  
	def cancel_membership
		@membership_sale = MembershipSale.find(params[:registration_id])
		@membership_sale.status_id = "w"
		@membership_sale.withdraw_datetime = Time.now
		@membership_sale.user_stamp = session[:staff_user_id]
		if @membership_sale.save
			flash[:notice] = "Membership successfully cancelled."
			@membership_sale = current_agency.registrations.new
			@account = Customer.includes(:account).where("accounts.id" => session[:account_id])
			@class_sessions = ClassSession.where("class_sessions.id" => session[:class_session_id])
			@seasons = current_agency.seasons.find(:all)
			@balance = Customer.where("account_id" => session[:account_id]).sum(:current_account_balance)
			render('memberships')
		else
			flash[:notice] = "Membership Could Not Be Cancelled"
			redirect(:action => 'memberships', :controller => 'membership_sales')
		end	
	end

	def lookup_account
		find_account
		render('accounts/index')
	end

  
end
