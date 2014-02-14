class ChannelsController < ApplicationController

	def index
	end

	def show
		@channel = Channel.find(params[:id], :include => :courses)
		@channel_courses = @channel.courses
	end

end
