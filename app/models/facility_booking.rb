class FacityBooking < ActiveRecord::Base
	belongs_to :agency
	has_one :facility
	belongs_to :class_session
	
  # attr_accessible :title, :body
end
