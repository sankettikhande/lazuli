class ChannelsController < ApplicationController

	def index
	end

	def show
		@channel = Channel.find(params[:channel_id])
		@course = Course.find(params[:id])
	end

end
