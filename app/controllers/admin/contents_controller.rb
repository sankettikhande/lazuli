class Admin::ContentsController < AdminController
	def index
		@videos = Video.all
		@courses = Course.all
		@topics = Topic.all
	end
end
