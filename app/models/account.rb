class Account < ActiveRecord::Base
	belongs_to :agency
	has_many :customers
	has_many :account_contacts
	belongs_to :city
	
	attr_accessor :password
	
	EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	
	validates :email, :presence => true
	validates_uniqueness_of :email
	validates :zip, :presence => true
	# only on create so other values can be modified later
	validates_length_of :password, :within => 7..25, :on => :create	
	#validates_length_of :password, :within => 7..25, :on => :update
	validates_confirmation_of :password, :on => :create
	
	
	before_save :create_hashed_password
	before_save :pwd
	
	after_save :clear_password
	
	attr_accessible :agency_id, :account_status_id, :email, :hashed_password, :salt, :barcode_number, :address, :address_2, :city_id, :state, :zip, :home_area, 
	:home_phone, :resident_flag, :current_balance, :future_balance, :unallocated_balance, :email_private, :alert_text, :user_stamp, :password, :password_confirmation
	
	def head_of_household(account_id)
		#head_of_household = Customer.where(:account_id => account_id, :head_of_household => 1)
		#"#{last_name}, #{first_name}"
	end
	
	def pwd
		@pwd = password
	end
	
	def clear_password
		self.password = nil
	end
	
	def self.hash_with_salt (password="", salt="")
		Digest::SHA1.hexdigest("put #{salt} on the #{password}")
	end

	def self.make_salt(email="")
		Digest::SHA1.hexdigest("Use the #{email} along with #{Time.now} to make salt")
	end
	
	def password_match? (password="")
		hashed_password == Account.hash_with_salt(password, salt)
	end
	
	def self.authenticate(email="", password="")
		account = Account.find_by_email(email)
		if account && account.password_match?(password)
			return account
		else
			return false
		end
	end
	

	
	private
	
	def create_hashed_password
		unless password.blank?
			self.salt = Account.make_salt(email) if salt.blank?
			self.hashed_password = Account.hash_with_salt(password, salt)
		end
	end
	
end
