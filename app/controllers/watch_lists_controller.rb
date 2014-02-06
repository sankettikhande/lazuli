class WatchListsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@videos = Video.cached_find(current_user.watch_lists.map(&:video_id))
	end
end
