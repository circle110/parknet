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
			flash[:notice] = "Brochure Subsection \"#{@brochure_subsection.name}\" Created."
			redirect_to(:action => 'list')
		else
			flash[:notice] = "Brochure Subsection creation failed"
			render('new')
		end		
	end
	
	def edit
		@brochure_subsection = BrochureSubsection.find(params[:id])
	end
	
	def update
		@brochure_subsection = BrochureSubsection.find(params[:id])
		if @brochure_subsection.update_attributes(params[:brochure_subsection])
			flash[:notice] = "Brochure Subsection \"#{@brochure_subsection.name}\" updated."
			redirect_to(:action => 'list')
		else
			flash[:notice] = "Brochure Subsection update failed"
			render('edit')
		end	
	end	
end
