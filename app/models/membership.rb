class Membership < ActiveRecord::Base

	belongs_to :agency
	belongs_to :membership_level_one
	belongs_to :membership_level_two
	belongs_to :membership_level_three
	has_many :membership_fees
	belongs_to :gl_account
	has_many :membership_sales
	
	attr_accessible :agency_id, :name, :membership_level_one_id, :membership_level_two_id, :membership_level_three_id, :membership_term_id, :membership_fee_id, :gl_account_id, :deferred_gl_account_id, :subscription_flag, :active, :user_stamp
	
	attr_accessible :membership_fees_attributes
	
	accepts_nested_attributes_for :membership_fees, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
	
	validates :agency_id, :name, :membership_level_one_id, :membership_level_two_id, :membership_level_three_id, :membership_term_id, :gl_account_id, :membership_fee_id, :deferred_gl_account_id, :subscription_flag, :active, :user_stamp, :presence => true
	

	
end

