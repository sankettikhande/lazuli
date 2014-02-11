class SharedController < ApplicationController
	before_filter :authenticate_user!

	def index
		klass = controller_name.classify
		@videos = klass.constantize.get_user_videos(current_user)
	end

	def search
		@videos = []
		klass = controller_name.classify
		video_ids = klass.constantize.get_video_ids_for(current_user)
		@videos = Video.sphinx_search(params, current_user, video_ids) unless video_ids.blank?
  end

end
