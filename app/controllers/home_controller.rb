class HomeController < ApplicationController
  def index
    if user_signed_in?
      @videos = Video.cached_scope('published', {:limit => Settings.data_count.latest_video }).in_groups_of(Settings.data_count.latest_video_frame, false)
      @courses = Course.public_channel_courses
    else
      @topics = Topic.cached_scope('published', {:limit => 6 }).in_groups_of(2, false)
      @courses = Course.public_channel_courses
      respond_to do |format|
        format.html{ render 'devise/sessions/new', :layout => 'devise' }
      end
    end
  end

  def browse_course
  end
end
