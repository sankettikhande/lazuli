class HomeController < ApplicationController
  def index
    if user_signed_in?
      @videos = Video.cached_scope('published', {:limit => Settings.data_count.latest_video })#.in_groups_of(Settings.data_count.latest_video_frame, false)
      @subscribed_courses = UserChannelSubscription.user_subscribed_courses(current_user)
      @courses = Course.public_channel_courses if @subscribed_courses.blank?
    else
      @topics = Topic.cached_scope('published', {:limit => 6 }).in_groups_of(2, false)
      @courses = Course.public_channel_courses
      respond_to do |format|
        format.html{ render 'devise/sessions/new', :layout => 'devise' }
      end
    end
  end
end
