class WatchListsController < SharedController
	def remove
		if params[:watch_lists_ids]
			WatchList.where(:video_id => params[:watch_lists_ids].keys, :user_id => current_user.id).destroy_all
			@videos = WatchList.get_user_videos(current_user)
		end
	end

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

	def remove_from_watch_list
		watchList = WatchList.where(:video_id => params[:id], :course_id => params[:course_id], :user_id => current_user.id).first
		if watchList
			watchList.destroy
			@alertClass = "success"
			@msg = "Video remove from watch list"
		end
		respond_to do |format|
			format.js {render '/favourites/destroy'}
		end
	end
end
