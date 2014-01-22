class CoursesController < ApplicationController
	layout 'application'
	def index
	end

	def show
		@channel = Channel.find(8)
		@course = Course.find(25)
	end

end
