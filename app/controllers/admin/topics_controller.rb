class Admin::TopicsController < AdminController

	def new
		@channel_courses = Course.all
		@topic = Topic.new
		@topic.videos.build()
	end

	def create
		@topic = Topic.new(params[:topic])
		if params[:SavePub]
			save_topic("Publish")
		elsif params[:Publish]
			publish_topic(@topic)
			#redirect_to :back, notice: "You have been Publish this Topic."
		elsif params[:Save]
			save_topic
		end

	end

	def edit
		@topic = Topic.cached_find(params[:id])
		channel = Channel.find(@topic.channel_id)
		@channel_courses = channel.courses
	end

	def update
		@topic = Topic.cached_find(params[:id])
		if params[:SavePub]
			update_topic(params[:topic], "Publish")
		elsif params[:Publish]
			publish_topic(@topic)
			redirect_to :back, notice: "You have been Publish this Topic."
		elsif params[:Save]
			update_topic(params[:topic])
		end
	end

	def destroy
		@topic = Topic.cached_find(params[:id])
		# @topic.delete_album_and_videos
		@topic.destroy
		respond_to do |format|
			format.html {redirect_to "#{admin_contents_url}#topics"}
		end
	end

	def bookmark
		@video = Video.find_by_id(params[:id])
		@video.bookmark = params["bookmark"].to_json
		@video.save
	end

  protected

	def update_topic(topic, publish=nil)
		respond_to do |format|
			if @topic.update_attributes(topic)
				publish_topic(@topic) if !publish.nil?
				if @topic.is_bookmark_video
					format.html{redirect_to edit_admin_topic_url(@topic)}
				else
					format.html{redirect_to "#{admin_contents_url}#topics"}
				end
			else
				@courses = Course.all
				format.html { render "edit" }
			end
		end
	end

	def save_topic(publish=nil)
		if @topic.save
			publish_topic(@topic) if !publish.nil?
			if @topic.is_bookmark_video
				redirect_to edit_admin_topic_url(@topic)
			else
				redirect_to "#{admin_contents_url}#topics"
			end
		else
			@courses = Course.all
			channel = Channel.find_by_id(@topic.channel_id)
			@channel_courses = channel.try(:courses) || []
			render "new"
		end
	end

	def publish_topic(topic)
		topic.update_attribute(:status, "Publish")
		topic.videos.first.upload_to_vimeo
	end
end
