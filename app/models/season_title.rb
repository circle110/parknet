class SeasonTitle < ActiveRecord::Base
	belongs_to :agency
	has_many :class_sessions
	has_many :seasons
	
	validates :name, presence: true
	
	attr_accessible :agency_id, :title, :gl_account_number, :active, :user_stamp
end
