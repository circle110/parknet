class City < ActiveRecord::Base
	belongs_to :agency
	has_many :accounts
	
  # attr_accessible :title, :body
end
