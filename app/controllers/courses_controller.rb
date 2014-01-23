class CoursesController < ApplicationController
	layout 'application'
	def index
	end

	def show
		@course = Course.find(params[:id])
	end

end
