class Admin::TopicsController < AdminController

	def new
		@courses = Course.all
		@topic = Topic.new
		@topic.videos.build()
	end

	def create
		@topic = Topic.new(params[:topic])
		if @topic.save
			@topic.videos.first.upload_to_vimeo
			redirect_to "#{admin_contents_url}#topics"
		else
			@courses = Course.all
			render "new"
		end
	end

	def edit
		@courses = Course.all
		@topic = Topic.cached_find(params[:id])
	end

	def update
		@topic = Topic.cached_find(params[:id])
		respond_to do |format|
			if @topic.update_attributes(params[:topic])
				@topic.videos.first.upload_to_vimeo
				format.html {redirect_to "#{admin_contents_url}#topics"}
			else
				@courses = Course.all
				format.html {render "edit"}
			end
		end
	end

	def destroy
		@topic = Topic.cached_find(params[:id])
		@topic.destroy
		respond_to do |format|
			format.html {redirect_to "#{admin_contents_url}#topics"}
		end
	end
end
