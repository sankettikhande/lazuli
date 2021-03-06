class WatchListsController < SharedController
	def remove
		WatchList.where(:video_id => params[:watch_lists_ids].keys, :user_id => current_user.id).destroy_all if params[:watch_lists_ids]
		@videos = WatchList.get_user_videos(current_user)
		respond_to do |format|
			format.js {render 'shared/remove'}
		end
	end

	def add_to_watch_list
		watchList = WatchList.new(:video_id => params[:id], :course_id => params[:course_id], :user_id => current_user.id , :title => params[:video_title], :thumbnail => params[:video_thumbnail])
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
			@msg = "Video removed from watch list"
		end
		respond_to do |format|
			format.js {render '/favourites/destroy'}
		end
	end
end
