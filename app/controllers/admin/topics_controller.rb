class Admin::TopicsController < AdminController

	def new
		@courses = Course.all
		@topic = Topic.new
	end

	def create
		@topic = Topic.new(params[:topic])
		if @topic.save
			redirect_to "#{admin_contents_url}#modules"
		else
			render "new"
		end
	end
end
