class HomeController < ApplicationController
  def index
    if user_signed_in?
      @videos = Video.cached_scope('published', {:limit => Settings.data_count.latest_video }).order("id desc")
      @subscribed_courses = UserChannelSubscription.user_subscribed_courses(current_user)
      @courses = Course.public_channel_courses(10) if @subscribed_courses.blank?
    else
      @topics =  Topic.published.not_bookmarked.limit(3)
      @courses = Course.public_channel_courses(3)
      respond_to do |format|
        format.html{ render 'devise/sessions/new', :layout => 'devise' }
      end
    end
  end

  def browse_course
    @channels = Channel.sphinx_search(params, current_user, "public")
    respond_to do |format|
      format.html{}
      format.js{ render 'channels/search'}
    end
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
