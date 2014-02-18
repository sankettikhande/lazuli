class CoursesController < ApplicationController
	layout 'application'
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
	def index
	end

	def show
		@course = Course.cached_find(params[:id])
		if @course.topics.published.any?
			@user_subscription = UserChannelSubscription.where(:channel_id => @course.channel_id, :user_id => current_user, :course_id => @course.id).first
			@video = load_video
			@topic = @video.topic
			@favourite_video = @video.favourites.where(:user_id => current_user).last
			@recommended_videos = load_recommended_videos
			authorize! :show, @video, :if => :video_param?
		else
			respond_to do |format|
				format.html { redirect_to root_url }
			end
		end
	end
	def search
		channel_courses_id=Channel.cached_find(params[:channel_id]).courses.map{|i| i.id}		
		@channel_courses= Course.sphinx_search(params, current_user, channel_courses_id)		
    end

	private
	def load_recommended_videos
		videos = @video.tags.any? ? Video.search(:conditions => sphinx_condition(@video.tags_str), :without => {:video_id => @video.id}).per(Settings.data_count.recommended.video) : []
	end

	def sphinx_condition(tags)
		tags.blank? ? {:status => 'Published'} : { :tags => tags, :status => 'Published' }
	end

	def load_video
		return Video.published.cached_find(params[:video_id]) if params[:video_id]
		return Topic.cached_find(params[:topic_id]).topic_first_video if params[:topic_id]
		@course.course_first_video
	end

	def video_param?
		params[:video_id]
	end
	
end
