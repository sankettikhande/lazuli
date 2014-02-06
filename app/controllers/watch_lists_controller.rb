class WatchListsController < ApplicationController
	before_filter :authenticate_user!
	def index
		watch_list = current_user.watch_lists.map(&:video_id)
		@videos = watch_list.any? ? Video.find(watch_list) : []
	end

	def remove
		if params[:checkbox]
			watch_list = params[:checkbox].keys.map{ |int| int.to_i}
			WatchList.where(:video_id => watch_list, :user_id => current_user.id).destroy_all
			watch_list = current_user.watch_lists.map(&:video_id)
			@videos = Video.find(watch_list)
		end
	end
end
