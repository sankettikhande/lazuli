class VideosController < ApplicationController
	before_filter :authenticate_user!

	def add_to_watch_list
		watchList = WatchList.new(:video_id => params[:id], :course_id => params[:course_id], :user_id => current_user.id)
		if watchList.save
			@alertClass = "success"
			@msg = "Video added to watch list"
		else
			@alertClass = "info"
			@msg = watchList.errors.full_messages.first
		end
		respond_to do |format|
      format.js {render '/favourites/create'}
    end
	end
end
