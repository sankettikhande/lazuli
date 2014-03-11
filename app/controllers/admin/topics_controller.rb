class Admin::TopicsController < AdminController
	before_filter :set_initialization, :only => [:new, :edit, :create, :update]
	load_and_authorize_resource
	

	def new
		@topic = Topic.new
		@channel_courses = []
		@topic_videos = @topic.videos.build()
	end

	def create
		@topic = Topic.new(params[:topic]) 
		@topic.created_by = current_user.id
		@topic.channel_admin_user_id = @topic.channel.admin_user_id
		@topic.course_admin_user_id = @topic.course.course_admin_user_id
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
		@channel_courses = @topic.channel.permitted_courses(current_user)
		@topic_videos = @topic.videos.order(:sequence_number)
		@bookmark_videos = @topic.videos.first.bookmarks.order("bookmark_sec") if @topic.is_bookmark_video
	end

	def update
		@topic = Topic.cached_find(params[:id])
		@topic.validate_uniq_videos params if params[:topic]
		@channel_courses = @topic.channel.permitted_courses(current_user)
		@bookmark_videos = @topic.videos.first.bookmarks.order("bookmark_sec") if @topic.is_bookmark_video

		if params[:SavePub]
			update_topic(params[:topic], "Published")
		elsif params[:Publish]
			publish_topic(@topic)
			redirect_to "#{admin_contents_url}#topics", notice: "Topic is being published. It will take some time. Please check status after some time."
		elsif params[:Save]
			@topic.update_attribute(:status, "PartialPublished") if @topic.errors.blank?
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

	def search
		@topics = Topic.sphinx_search(params, current_user)
	end

	def topic_videos
		@topic = Topic.cached_find(params[:id])
	end

  protected

  def set_initialization
  	@channels = current_user.permitted_channels
  end

	def update_topic(topic, publish=nil)
		respond_to do |format|
			if @topic.errors.blank? && @topic.update_attributes(topic)
				publish_topic(@topic) if !publish.nil?
				notice = publish.nil? ? "Topic has been successfully Updated." : "Topic is being published. It will take some time. Please check status after some time."
				if @topic.is_bookmark_video
					format.html{redirect_to "#{admin_contents_url}#topics", notice: notice}
				else
					format.html{redirect_to "#{admin_contents_url}#topics", notice: notice}
				end
			else
				@courses = Course.cached_all
				format.html { render "edit" }
			end
		end
	end

	def save_topic(publish=nil)
		if @topic.save
			publish_topic(@topic) if !publish.nil?
			notice = publish.nil? ? "Topic has been successfully Saved." : "Topic is being published. It will take some time. Please check status after some time."
			if @topic.is_bookmark_video
				redirect_to edit_admin_topic_url(@topic), notice: notice
			else
				redirect_to "#{admin_contents_url}#topics", notice: notice
			end
		else
			@courses = Course.cached_all
			channel = Channel.cached_find(@topic.channel_id)
			@channel_courses = channel.try(:courses) || []
			render "new"
		end
	end

	def publish_topic(topic)
		topic.update_attribute(:status, "InProcess")
		topic.upload_to_vimeo
	end
end
