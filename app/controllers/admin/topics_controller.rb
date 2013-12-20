class Admin::TopicsController < AdminController

	def new
		@courses = Course.all
		@topic = Topic.new
		@topic.videos.build()
	end

	def create
		@topic = Topic.new(params[:topic])
		if @topic.save
			upload_video(@topic)
			redirect_to "#{admin_contents_url}#topics"
		else
			@courses = Course.all
			render "new"
		end
	end

	def edit
		@courses = Course.all
		@topic = Topic.find_by_id(params[:id])
	end

	def update
		@topic = Topic.find_by_id(params[:id])
		respond_to do |format|
			if @topic.update_attributes(params[:topic])
				upload_video(@topic)
				format.html {redirect_to "#{admin_contents_url}#topics"}
			else
				@courses = Course.all
				format.html {render "edit"}
			end
		end
	end

	def destroy
		@topic = Topic.find_by_id(params[:id])
		@topic.destroy
		respond_to do |format|
			format.html {redirect_to "#{admin_contents_url}#topics"}
		end
	end

	private

	def upload_video(topic)
		topic.videos.each do |video|
			video.upload_to_vimeo
		end
	end
end
