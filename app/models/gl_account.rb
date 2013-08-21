class GlAccount < ActiveRecord::Base
	belongs_to :agency
	belongs_to :fund, inverse_of: :gl_accounts
	has_many :class_sessions
	has_many :facilities
	
	validates :agency_id, :fund, :name, :gl_account_number, :active, :user_stamp, :account_type, :presence => true
	validates_uniqueness_of :account_type, :scope => :fund_id, :if => :unique_account_type
	
	attr_accessible :agency_id, :fund_id, :name, :gl_account_number, :active, :user_stamp, :account_type
	
	def unique_account_type
		[3,4,6,7,8].include? account_type
	end
	
	def number_name
		"#{gl_account_number} - #{name}"
	end
end
