class ChannelsController < ApplicationController

	def index
	end

	def show
		parent=request.referrer
		@channel = Channel.cached_find(params[:id])		 
		@channel_courses = @channel.published_topic_courses
		if parent
			parent = parent.split('/').last
			@main_parent = (parent == 'browse_course') ? 'Browse Our Library' : 'Our Partners'
		end 	
	end

	def search
		@channels = Channel.sphinx_search(params, current_user, "public")
	end
end
