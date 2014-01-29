class HomeController < ApplicationController
	def index
  	if user_signed_in?
  		@videos = Video.published.order('created_at').limit(Settings.data_count.latest_video).in_groups_of(Settings.data_count.latest_video_frame, false)
  		@courses = Course.last(Settings.data_count.courses)
  	else
  		@courses = Course.last(3)
  		respond_to do |format|
	      format.html{ render 'devise/sessions/new', :layout => 'devise' }
	    end
  	end
  end
end
