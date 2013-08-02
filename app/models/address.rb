class Address < ActiveRecord::Base
	belongs_to :agency
	has_one :account
	
  # attr_accessible :title, :body
end
