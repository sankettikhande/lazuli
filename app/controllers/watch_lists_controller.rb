class WatchListsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@watch_list = current_user.watch_lists
	end
end
