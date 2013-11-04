class MembershipScansController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in
	
	def new
		@membership_scan = current_agency.membership_scans.new
	end
	
	def create
		@membership_scan = current_agency.membership_scans.new(params[:membership_scan])
		customer_id = params[:membership_scan][:customer_id]
		@customer = Customer.find(customer_id)
		customer_name = @customer.full_name
		right_now = Time.now
		@has_membership = MembershipSale.where("customer_id = ? AND expiry_date > ?", customer_id, right_now)
		if @has_membership.count > 0
			@scans = MembershipScan.where("agency_id = ? AND customer_id = ?", session[:agency_id], customer_id).order(:created_at)
			if right_now - @scans.last.created_at < 10.minutes
				double_scan = 'Customer previously scanned in less than 10 minutes ago.'
			end
			@just_scanned = 1
			@membership = Membership.find(@has_membership.first.membership_id)
			@membership_scan.membership_id = @membership.id
			@membership_scan.membership_sale_id = @has_membership.first.id
			if @membership_scan.save
				flash[:notice] = "#{customer_name} Scanned in at #{right_now}"
			else
				flash[:notice] = "#{customer_name} Scan Failed. #{double_scan}"
			end
		else
			flash[:notice] = "#{customer_name} - No Current Membership"
		end
		@membership_scan = current_agency.membership_scans.new
		render('new')
	end





end
