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
			@bookmark= load_bookmark if params[:t]	
			@favourite_video = @video.favourites.where(:user_id => current_user).last
			@recommended_videos = load_recommended_videos
			@course_subscriptions = @course.available_course_subscriptions
			@current_subscription = current_user.current_subscription(@course.id ) if current_user
			respond_to do |format|
				format.html {}
				format.js { render 'change_bookmark'}
			end
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

	def list
		@course = Course.cached_find(params[:id])		
		@course_topics = @course.topics.published
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
		return Topic.cached_find(params[:topic_id]).topic_first_video(current_user) if params[:topic_id]
		@course.course_first_video(current_user)
	end

	def load_bookmark		
	    if params[:t]
	       bookmark_sec= bookmark_sec_format(params[:t])	       
	       return @video.bookmarks.find_by_bookmark_sec(bookmark_sec) if bookmark_sec
	    end	   
	end

	def bookmark_sec_format(time)
		str= time
    	if str.include?('h') || str.include?('m')
	        str= str.include?('h') ? str.gsub('h',':') : str.insert(0, '00:') 
		    str= str.include?('m') ? str.gsub('m',':') : str << '00:' 
		    str = str.include?('s') ? str.gsub('s','') : str << '00'
		    bookmarks_time= DateTime.parse(str).strftime("%H:%M:%S").split(":")
	        bookmark_sec = bookmarks_time.first.to_i * 3600 + bookmarks_time.second.to_i * 60 + bookmarks_time.third.to_i
	    else
	        bookmark_sec = str.include?('s') ?  str.gsub('s','') : "" 
	    end 
	    return bookmark_sec unless bookmark_sec.blank?  
    end		

	def video_param?
		params[:video_id]
	end
	
end
