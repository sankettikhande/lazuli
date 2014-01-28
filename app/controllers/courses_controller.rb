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
		videos = Video.search(:conditions => sphinx_condition(@video.tags_str)).per(Settings.data_count.recommended.video)
		return videos.in_groups(Settings.data_count.recommended.video_frame_count, false) if videos.size > Settings.data_count.recommended.video_frame
		return videos.in_groups(1, false)
		# Need more specific requirement
		# Video.published.last(Settings.data_count.recommended.video)
	end

	def sphinx_condition(tags)
		tags.blank? ? {:status => 'Published'} : { :tags => tags, :status => 'Published' }
	end

	def load_video
		return Video.published.find(params[:video_id]) if params[:video_id]
		@course.course_first_video
	end
end
