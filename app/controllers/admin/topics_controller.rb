class Admin::TopicsController < AdminController

	def new
		@courses = Course.all
		@topic = Topic.new
	end

	def create
		@topic = Topic.new(params[:topic])
		if @topic.save
			redirect_to "#{admin_contents_url}#topics"
		else
			@courses = Course.all
			render "new"
		end
	end

	def edit
		@courses = Course.all
		@topic = Topic.find_by_id(params[:id])
		render "edit"
	end

	def update
		@topic = Topic.find_by_id(params[:id])
		respond_to do |format|
			if @topic.update_attributes(params[:topic])
				format.html {redirect_to "#{admin_contents_url}#topics"}
			else
				format.html {render "edit"}
			end
		end
	end
end
