class Admin::ContentsController < AdminController
	def index
		@courses = Course.all
		@topics = Topic.all
	end
end
