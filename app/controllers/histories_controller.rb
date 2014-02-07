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

	def save_history
		history = History.find_by_video_id_and_user_id(params[:id],current_user.id)
		history.increment!(:view_count) if history
		History.create(:video_id => params[:id], :user_id => current_user.id) if !history
		respond_to do |format|
			format.js { render :nothing => true }
		end
	end
end