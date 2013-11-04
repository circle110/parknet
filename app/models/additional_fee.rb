class AdditionalFee < ActiveRecord::Base


	attr_accessible :agency_id, :user_stamp, :fee_amount, :name, :fee_type, :active
	
	def name_amount
		"$#{fee_amount.round(2)} -- #{name}"
	end
end
