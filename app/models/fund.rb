class Fund < ActiveRecord::Base
	belongs_to :agency
	has_many :gl_accounts, inverse_of: :fund
	
	accepts_nested_attributes_for :gl_accounts
	
	attr_accessible :name, :agency_id, :fund, :user_stamp, :active
	attr_accessible :gl_accounts_attributes
	
	def number_name
		"#{fund} - #{name}"
	end 
	
end
