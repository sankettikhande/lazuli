class ChannelsController < ApplicationController

	def index
	end

	def show		
		@channel = Channel.cached_find(params[:id])		 
		@channel_courses = @channel.published_topic_courses		
	end

	def search
		@channels = Channel.sphinx_search(params, current_user, "public")
	end
end
