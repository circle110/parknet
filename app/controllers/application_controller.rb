class ApplicationController < ActionController::Base
  protect_from_forgery
  
    private 
	
	before_filter :set_locale
	 
	def set_locale
	  I18n.locale = extract_locale_from_subdomain || I18n.default_locale
	end
	
	def extract_locale_from_subdomain
		parsed_locale = request.subdomains.first
		I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : nil
	end
  
	def confirm_logged_in
		unless session[:staff_user_id]
			flash[:notice] = "Please log in."
			redirect_to(:action => 'login', :controller => 'staff_access')
			return false # halts the before filter
		else
			return true
		end
	end

	def confirm_customer_logged_in
		unless session[:customer_account_id]
			flash[:notice] = "Please log in."
			redirect_to(:action => 'login', :controller => 'customer_access')
			return false # halts the before filter
		else
			return true
		end
	end
	
	def current_agency
		@current_agency ||= Agency.find(session[:agency_id])
	end
	
	def current_user
		current_user ||= StaffUser.find(session[:staff_user_id])
	end
	
	rescue_from CanCan::AccessDenied do |exception|
		redirect_to :back, :alert => 'You do not have sufficient rights for that action.'
	end
  
    def find_program
		search_text = params[:search_text]
		@programs = current_agency.class_sessions.includes(:program).where("class_sessions.season_id = ? AND (programs.name like ? OR programs.code = ? OR programs.id = ?)", params[:season_id], "%#{search_text}%", search_text, params[:program_id]).collect
		@seasons = Season.find(:all)
	end
	
	
	def find_account
		if params[:account_id]
			@customers = Customer.includes(:account).where("accounts.id = ?", params[:account_id])
		else
			search_text = params[:search_text] 
			if search_text.respond_to?(:to_str)
				last_name = search_text
			else
				last_name = ""
			end
			if search_text.match /^\d+(?:-\d+)*$/
				phone = search_text
				phone = phone.sub!(/-/, '')
				phone = phone.sub!(/./, '')
				#phone = phone.sub!(/(/, '')
				#phone = phone.sub!(/)/, '')
			else
				phone = ""
			end
			@customers = current_agency.customers.includes(:account).where("customers.last_name like ? OR accounts.home_phone = ?", "%#{last_name}%", phone).order("account_id", "last_name", "first_name")
		end	
	end
	
	def headshot_custom_file_path
		file_name = "headshot_capture_#{rand(10000)}_#{Time.now.to_i}.jpg"
		File.join(Rails.root, 'public', 'headshots_images', file_name)
	end
  
end
