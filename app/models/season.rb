class Season < ActiveRecord::Base
	belongs_to :agency
	belongs_to :season_title
	
	attr_accessible :agency_id, :season_year, :season_title_id, :default_registration_start_date, :active, :default_internet_display_date, 
	:default_nr_registration_start_date, :member_registration_start_date, :registration_start_time, :user_stamp
	
	def season_name_year
		season_title = SeasonTitle.find(season_title_id)
		season_name = season_title.title
		return season_name + " - " + season_year
	end
end
