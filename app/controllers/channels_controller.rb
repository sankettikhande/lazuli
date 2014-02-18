class ChannelsController < ApplicationController

	def index
	end

	def show
		@channel = Channel.cached_find(params[:id])
		@channel_courses = @channel.published_topic_courses
	end

end
