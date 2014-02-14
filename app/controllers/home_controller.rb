class HomeController < ApplicationController
  def index
    if user_signed_in?
      @videos = Video.cached_scope('published', {:limit => Settings.data_count.latest_video })
      @subscribed_courses = UserChannelSubscription.user_subscribed_courses(current_user)
      @courses = Course.all_public_channel_courses.take(10) if @subscribed_courses.blank?
    else
      @topics =  Topic.published.not_bookmarked.limit(3)
      @courses = Course.public_channel_courses
      respond_to do |format|
        format.html{ render 'devise/sessions/new', :layout => 'devise' }
      end
    end
  end

  def browse_course
    @channels = Channel.public_channels
  end
  
  def search
    filter_options, sql_options = {}, {}
    options = {:star => true, :per_page => 50}
    filter_options.merge!(:conditions => {:topic_status => "published"})
    sql_options.merge!(:sql => {:include => [:channel, :topics]})
    options.merge!(filter_options).merge!(sql_options)
    @courses = Course.search params[:search], options
  end
end
