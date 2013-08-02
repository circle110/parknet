class ClassSessionFeesController < ApplicationController

	layout "staff"
	
	before_filter :confirm_logged_in
	
	def new
		@fee = ClassSessionFee.new(:class_session_id => params[:class_session_id])
	end
	
	def create
		@fee = ClassSessionFee.new(params[:class_session_fee])
		if @fee.save
			redirect_to(:action => 'edit', :controller => 'class_sessions', :id => params[:class_session_fee][:class_session_id])
		else
			render('new')
		end	
	end
	
	def edit
		@class_session_fee = ClassSessionFee.find(params[:id])
	end
	
	def update
		@class_session_fee = ClassSessionFee.find(params[:id])
		if @class_session_fee.update_attributes(params[:class_session_fee])
			flash[:notice] = "Fee edits saved."
			redirect_to(:action => 'edit', :controller => 'class_sessions', :id => params[:class_session_fee][:class_session_id])
		else
			render('edit')
		end	
	end
	
	
end	