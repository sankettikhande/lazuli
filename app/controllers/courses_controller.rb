class CoursesController < ApplicationController
	layout 'application'
	def index
	end

	def show
		@course = Course.find(params[:id])
		@video = Video.where(query_condition).find_by_id(params[:video_id]) if params[:video_id]
		@video_tags = @video ? @video.tags : []
		@recommended_videos = load_recommended_videos
	end

	private
	def load_recommended_videos
		if @video && @video_tags.any?
			Video.search(:conditions => sphinx_condition(@video.tags_str)).per(12)
		else
			Video.where(query_condition).last(12)
		end
	end

	def sphinx_condition(tags)
		tags.blank? ? {:status => 'Published'} : { :tags => tags, :status => 'Published' }
	end

	def query_condition
		{:status => 'Published'}
	end

end
