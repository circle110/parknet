class BrowseProgramsController < ApplicationController

	layout "browse"
	
	def browse
		@program = Program.find(params[:id])
	end
	
	
  def show
  	@program = Program.find(params[:id])

  end
  
  def list
	if params[:kid]
		#kid_birthdate = DateTime.new(params["kid"]["birthdate1(1i)"].to_i, 
									#params["kid"]["birthdate1(2i)"].to_i,
									#params["kid"]["birthdate1(3i)"].to_i,)
		#kid_age = Date.today - kid_birthdate
		kid_age = 6
		@programs = Program.where("min_age < #{kid_age} and max_age > #{kid_age}")
	else
		@programs = Program.where("name like ?", "%" + params[:text] + "%")
	end
  end
  
end
