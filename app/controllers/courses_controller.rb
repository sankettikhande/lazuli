class CoursesController < ApplicationController
	layout 'application'
	def index
	end

	def show
		@course = Course.find(params[:id])
		@video = Video.find(params[:video_id]) if params[:video_id]
	end

end
