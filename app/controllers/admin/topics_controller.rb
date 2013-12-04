class Admin::TopicsController < AdminController

	def new
		@topic = Topic.new
	end
end
