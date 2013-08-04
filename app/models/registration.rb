class Registration < ActiveRecord::Base
	belongs_to :agency
	belongs_to :customer
	belongs_to :class_session
	belongs_to :program
	
	attr_accessible :agency_id, :customer_id, :class_session_id, :user_stamp, :fee_amount, :creation_user_stamp
	
	validates :agency_id, :presence => true
	validates :customer_id, :presence => true
	validates :user_stamp, :presence => true
	validates :creation_user_stamp, :presence => true
	validates :fee_amount, :presence => true
	validates :class_session_id, :presence => true
	validates_uniqueness_of :customer_id, :scope => :class_session_id, :message => ' selected is already registered for that class.'
	
	#before_create :update_accounting_transactions
	#before_create :update_account_balance
	#before_create :update_class_num_registered
	#before_create :update_waitlist
	
	
	

end
