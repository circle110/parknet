class Location < ActiveRecord::Base
	belongs_to :agency


	attr_accessible :agency_id, :name
	

end
