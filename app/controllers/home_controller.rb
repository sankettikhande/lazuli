class HomeController < ApplicationController
	skip_before_filter :authenticate_user!
  def index
  	if user_signed_in?
  		@videos = Video.published.order('created_at').limit(Settings.data_count.latest_video)
  		@courses = Course.last(Settings.data_count.courses)
  	else
  		@courses = Course.last(3)
  		respond_to do |format|
	      format.html{ render 'devise/sessions/new', :layout => 'devise' }
	    end
  	end
  end
end
