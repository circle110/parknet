class BrochureSubsectionsController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in

	def list
		@brochure_subsections = BrochureSubsection.order("brochure_subsections.brochure_section_id, brochure_subsections.name ASC")
	end
	
	def show
	
	end
	
	def new	
		@brochure_subsection = BrochureSubsection.new
	end
	
	def create
		@brochure_subsection = BrochureSubsection.new(params[:brochure_subsection])
		if @brochure_subsection.save
			redirect_to(:action => 'list')
		else
			render('new')
		end		
	end
	
	def edit
		@brochure_subsection = BrochureSubsection.find(params[:id])
	end
	
	def update
		@brochure_subsection = BrochureSubsection.find(params[:id])
		if @brochure_subsection.update_attributes(params[:brochure_subsection])
			redirect_to(:action => 'list')
		else
			render('edit')
		end	
	end	
end
