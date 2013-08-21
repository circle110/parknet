class Payment < ActiveRecord::Base
	belongs_to :agency 
	has_many :payment_allocations
	
	accepts_nested_attributes_for :payment_allocations

	attr_accessible :agency_id, :user_stamp, :location_id, :account_id, :payment_type_id, :amount, :check_number, :creation_user_stamp, :stripe_token, :class_session_id
	attr_accessible :payment_allocations_attributes
	
	attr_accessor :class_session_id
	
	validates :agency_id, :user_stamp, :location_id, :account_id, :payment_type_id, :amount, :creation_user_stamp, :presence => true
	validates :stripe_token, :presence => true, :if => :only_for_credit_cards
	validates :check_number, :presence => true, :if => :only_for_checks
	
  
	def only_for_credit_cards
		payment_type_id == 3
	end
	
	def only_for_checks
		payment_type_id == 2
	end
  
end
