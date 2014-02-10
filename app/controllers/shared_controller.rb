class SharedController < ApplicationController
	before_filter :authenticate_user!

	def search
		@videos = []
		klass = controller_name.classify
		video_ids = klass.constantize.get_video_ids_for(current_user)
		@videos = Video.sphinx_search(params, current_user, video_ids) unless video_ids.blank?
  end

end
