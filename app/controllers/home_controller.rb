class HomeController < ApplicationController
  def index
    if user_signed_in?
      @videos = Video.cached_scope('published', {:limit => Settings.data_count.latest_video })
      @subscribed_courses = UserChannelSubscription.user_subscribed_courses(current_user)
      @courses = Course.public_channel_courses if @subscribed_courses.blank?
    else
      @topics =  Topic.published.not_bookmarked.limit(3)
      @courses = Course.public_channel_courses
      respond_to do |format|
        format.html{ render 'devise/sessions/new', :layout => 'devise' }
      end
    end
  end

  def browse_course
    @subscribed_courses = UserChannelSubscription.user_subscribed_courses(current_user)
  end
end
