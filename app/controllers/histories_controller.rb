class HistoriesController < ApplicationController
	before_filter :authenticate_user!
	def index
		@videos = History.get_user_videos(current_user)
	end

	def remove
		if params[:history_ids]
			histories_list = params[:history_ids].keys.map{ |int| int.to_i}
			History.where(:video_id => histories_list, :user_id => current_user.id).destroy_all
			@videos = History.get_user_videos(current_user)
		end
	end
end