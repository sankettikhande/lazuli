class CoursesController < ApplicationController
	layout 'application'
	def index
	end

	def show
		@course = Course.find(params[:id])
		@video = Video.published.find(params[:video_id]) if params[:video_id]
		@video_tags = @video ? @video.tags : []
		@recommended_videos = load_recommended_videos
	end

	private
	def load_recommended_videos
		if @video && @video_tags.any?
			Video.search(:conditions => sphinx_condition(@video.tags_str)).per(Settings.data_count.recommended_video)
		else
			Video.published.last(Settings.data_count.recommended_video)
		end
	end

	def sphinx_condition(tags)
		tags.blank? ? {:status => 'Published'} : { :tags => tags, :status => 'Published' }
	end
end
