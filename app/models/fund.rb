class Fund < ActiveRecord::Base
	belongs_to :agency

	
	attr_accessible :name, :agency_id, :fund, :user_stamp, :active
	
	def number_name
		"#{fund} - #{name}"
	end
	
end
