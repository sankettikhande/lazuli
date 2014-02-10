class CoursesController < ApplicationController
	layout 'application'
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
	def index
	end

	def show
		@course = Course.cached_find(params[:id])
		@user_subscription = UserChannelSubscription.where(:channel_id => @course.channel_id, :user_id => current_user, :course_id => @course.id).first
		@video = load_video
		@favourite_video = @video.favourites.where(:user_id => current_user).last
		@recommended_videos = load_recommended_videos
		authorize! :show, @video, :if => :video_param?
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

	def video_param?
		params[:video_id]
	end
end
