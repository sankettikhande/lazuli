class CoursesController < ApplicationController
	layout 'application'
	def index
	end

	def show
		@course = Course.find(params[:id])
		@video = load_video
		@recommended_videos = load_recommended_videos
	end

	private
	def load_recommended_videos
		return Video.search(:conditions => sphinx_condition(@video.tags_str)).per(Settings.data_count.recommended_video) if @video && @video.tags.any?
		Video.published.last(Settings.data_count.recommended_video)
	end

	def sphinx_condition(tags)
		tags.blank? ? {:status => 'Published'} : { :tags => tags, :status => 'Published' }
	end

	def load_video
		return Video.published.find(params[:video_id]) if params[:video_id]
		@course.course_first_video
	end
end
