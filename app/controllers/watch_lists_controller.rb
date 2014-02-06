class WatchListsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@videos = WatchList.get_user_videos(current_user)
	end

	def remove
		if params[:watch_list_ids]
			watch_list = params[:watch_list_ids].keys.map{ |int| int.to_i}
			WatchList.where(:video_id => watch_list, :user_id => current_user.id).destroy_all
			@videos = WatchList.get_user_videos(current_user)
		end
	end
end
