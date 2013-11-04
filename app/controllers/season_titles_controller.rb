class SeasonTitlesController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def index
		@season_titles = SeasonTitle.order("season_titles.id ASC")
	end
	
	def show
	
	end
	
	def new	
		@season_title = SeasonTitle.new
	end
	
	def create
		@season_title = SeasonTitle.new(params[:season_title])
		if @season_title.save
			redirect_to(:action => 'index')
		else
			render('new')
		end		
	end
	
	def edit
		@season_title = SeasonTitle.find(params[:id])
	end
	
	def update
		@season_title = SeasonTitle.find(params[:id])
		if @season_title.update_attributes(params[:season_title])
			redirect_to(:action => 'index')
		else
			render('edit')
		end	
	end	
end
