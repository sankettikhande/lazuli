class HistoriesController < SharedController
	def index
		@videos = History.get_user_videos(current_user)
	end

	def remove
		if params[:history_ids]
			History.where(:video_id => params[:histories_ids].keys, :user_id => current_user.id).destroy_all
			@videos = History.get_user_videos(current_user)
		end
	end
end