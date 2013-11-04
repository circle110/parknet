class BrochureSectionsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def index
		@brochure_sections = BrochureSection.order("brochure_sections.name ASC")
	end
	
	def show
	end
	
	def new	
		@brochure_section = BrochureSection.new
	end
	
	def create
		@brochure_section = BrochureSection.new(params[:brochure_section])
		if @brochure_section.save
			redirect_to(:action => 'index')
		else
			flash[:notice] = "Creation of new Brochure Section Failed"
			render('new')
		end		
	end
	
	def edit
		@brochure_section = BrochureSection.find(params[:id])
	end
	
	def update
		@brochure_section = BrochureSection.find(params[:id])
		if @brochure_section.update_attributes(params[:brochure_section])
			flash[:notice] = "Brochure Section \"#{params[:brochure_section][:name]}\" has been updated."
			redirect_to(:action => 'index')
		else
			flash[:notice] = "Update of Brochure Section Failed"
			render('edit')
		end	
	end	
end
