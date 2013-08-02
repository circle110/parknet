class GlAccount < ActiveRecord::Base
	belongs_to :agency
	belongs_to :fund
	has_many :class_sessions
	has_many :facilities
	
	attr_accessible :agency_id, :fund_id, :name, :gl_account_number, :active, :user_stamp
	
	def number_name
		"#{gl_account_number} - #{name}"
	end
end
