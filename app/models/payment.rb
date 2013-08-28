class Payment < ActiveRecord::Base
	belongs_to :agency 
	has_many :payment_allocations
	
	accepts_nested_attributes_for :payment_allocations

	attr_accessible :agency_id, :user_stamp, :location_id, :account_id, :payment_type_id, :amount, :check_number, :creation_user_stamp, :stripe_token, :class_session_id, :registration_basket_id, :online
	attr_accessible :payment_allocations_attributes
	
	attr_accessor :class_session_id
	attr_accessor :registration_basket_id
	attr_accessor :online
	
	validates :agency_id, :user_stamp, :location_id, :account_id, :payment_type_id, :amount, :creation_user_stamp, :presence => true
	validates :stripe_token, :presence => true, :if => :only_for_credit_cards
	validates :check_number, :presence => true, :if => :only_for_checks
	
	after_create :create_registrations_and_allocations, :if => :online_transaction
	after_create :update_registration_basket, :if => :online_transaction
	
	def online_transaction
		online == "y"
	end
  
	def only_for_credit_cards
		payment_type_id == 3
	end
	
	def only_for_checks
		payment_type_id == 2
	end
	
	def create_registrations_and_allocations #convert each basket item into a registration record and make the related payment allocation
		registrations_in_basket = RegistrationBasketLineItem.where("registration_basket_id = ?", registration_basket_id)
		registrations_in_basket.each do |r|
			if r.waitlist_flag == 1
				status_id = "w"
			else
				status_id = "a"
			end
			registration = Registration.new(
				:agency_id => agency_id,
				:status_id => status_id,
				:user_stamp => 0, # 0 is the system ID
				:creation_user_stamp => 0, # 0 is the system ID
				:class_session_id => r.class_session_id,
				:customer_id => r.customer_id,
				:fee_amount => r.fee_amount
			)
			registration.save
			
			payment_allocation = PaymentAllocation.new(
				:agency_id => agency_id,
				:payment_id => id,
				:allocation_type => 0, # I have to decide what I want here
				:reference_id => registration.id,
				:amount => r.fee_amount,
				:user_stamp => 0, # 0 is the system ID
				:creation_user_stamp => 0, # 0 is the system ID
				:class_session_id => r.class_session_id,
				:customer_id => r.customer_id
			)
			payment_allocation.save			
		end
	end
	
	def update_registration_basket # update registration basket to show paid/completed
		registration_basket = RegistrationBasket.find(registration_basket_id)
		registration_basket.status_id = 2
		registration_basket.save
	end
  
end
