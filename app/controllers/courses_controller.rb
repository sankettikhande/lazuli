class CoursesController < ApplicationController
	layout 'application'
	def index
	end

	def show
		@course = Course.cached_find(params[:id])
		@user_subscription = UserChannelSubscription.where(:channel_id => @course.channel_id, :user_id => current_user.id, :course_id => @course.id).limit(1)
		@video = load_video
		@favourite_video = @video.favourites.where(:user_id => current_user.id).last
		@recommended_videos = load_recommended_videos
	end

	private
	def load_recommended_videos
		videos = @video.tags.any? ? Video.search(:conditions => sphinx_condition(@video.tags_str), :without => {:video_id => @video.id}).per(Settings.data_count.recommended.video) : []
		return videos.in_groups_of(Settings.data_count.recommended.video_frame, false)
		# Need more specific requirement
		# Video.published.last(Settings.data_count.recommended.video)
	end

	def sphinx_condition(tags)
		tags.blank? ? {:status => 'Published'} : { :tags => tags, :status => 'Published' }
	end

	def load_video
		return Video.published.cached_find(params[:video_id]) if params[:video_id]
		@course.course_first_video
	end
end
