class StaffUser < ActiveRecord::Base
	belongs_to :agency
	has_many :staff_supervisors
	
	attr_accessor :password
	
	#require 'BCrypt'
	
	EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	
	validates :first_name, :last_name, :email, :presence => true
	# only on create so other values can be modified later
	validates_length_of :password, :within => 7..25, :on => :create	
	validates_confirmation_of :password, :on => :create 
	validates_uniqueness_of :email
	
	
	before_save :create_hashed_password
	
	after_save :clear_password
	
	
	attr_accessible :agency_id, :first_name, :last_name, :email, :security_group, :is_supervisor, :user_stamp, :password, :password_confirmation
	
	def full_name_last_first
		"#{last_name}, #{first_name}"
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
		hashed_password == StaffUser.hash_with_salt(password, salt)
	end
	
	def self.authenticate(email="", password="")
		staff_user = StaffUser.find_by_email(email)
		if staff_user && staff_user.password_match?(password)
			return staff_user
		else
			return false
		end
	end
	

	
	private
	
	def create_hashed_password
		unless password.blank?
			self.salt = StaffUser.make_salt(email) if salt.blank?
			self.hashed_password = StaffUser.hash_with_salt(password, salt)
		end
	end
	

	
end
