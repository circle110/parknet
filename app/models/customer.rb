class Customer < ActiveRecord::Base
	belongs_to :agency
	belongs_to :account
	has_one :address
	has_one :staff_user
	has_one :city, through: :account
	has_many :accounting_transactions
	has_many :refunds
	has_many :memberships
	
	include HasBarcode

	
	attr_accessible :agency_id, :account_id, :first_name, :last_name, :head_of_household_flag, :email, :status_id, :birthdate, :head_of_household_flag, 
	:gender_id, :alert_text, :user_stamp
	
	#validates :email, :uniqueness => true
	
	
	has_barcode :barcode,
		:outputter => :svg,
		:type => :code_39,
		:value => Proc.new { |p| "#{p.id}" }
	
	def full_name
		"#{first_name} #{last_name}"
	end
	
	def full_name_last_first
		"#{last_name}, #{first_name}"
	end

	
end

