class Admin::TopicsController < AdminController
	load_and_authorize_resource
	rescue_from CanCan::AccessDenied do |exception|
	  redirect_to root_url, :alert => exception.message
	end
	def new
		set_initialization
		@topic = Topic.new
		@topic_videos = @topic.videos.build()
	end

	def create
		@topic = Topic.new(params[:topic]) 
		@topic.created_by = current_user.id
		@topic.channel_admin_user_id = @topic.channel.admin_user_id
		@topic.course_admin_user_id = @topic.course.course_admin_user_id
		@topic.videos.each do |video|
			video.created_by = current_user.id
			video.channel_admin_user_id = @topic.channel_admin_user_id
			video.course_admin_user_id = @topic.course_admin_user_id
		end
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
		edit_initialization
		@topic_videos = @topic.videos.order(:sequence_number)
		@bookmark_videos = @topic.videos.first.bookmarks.order("bookmark_sec") if @topic.is_bookmark_video
	end

	def update
		@topic = Topic.cached_find(params[:id])
		@topic.validate_uniq_videos params if params[:topic]
		@channel_courses = @topic.channel.courses
		@bookmark_videos = @topic.videos.first.bookmarks.order("bookmark_sec") if @topic.is_bookmark_video
		if params[:SavePub]
			update_topic(params[:topic], "Publish")
		elsif params[:Publish]
			publish_topic(@topic)
			redirect_to :back, notice: "Topic is being published. It will take some time. Please check status after some time."
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
  	@channel_courses = []
	if current_user.is_admin?
		@channels =Channel.all
	else
		channel_ids = Course.where("channel_admin_user_id =? OR course_admin_user_id = ?", current_user.id,current_user.id).select("DISTINCT channel_id").map(&:channel_id)
		@channels = Channel.where(:id => channel_ids)
	end
  end

  def edit_initialization
  	@topic = Topic.cached_find(params[:id])
  	@channel_courses = @topic.channel.permitted_courses(current_user)
	if current_user.is_admin?
		@channels =Channel.all
	else
		channel_ids = Course.where("channel_admin_user_id =? OR course_admin_user_id = ?", current_user.id,current_user.id).select("DISTINCT channel_id").map(&:channel_id)
		@channels = Channel.where(:id => channel_ids)
	end
  end

	def update_topic(topic, publish=nil)
		respond_to do |format|
			if @topic.errors.blank? && @topic.update_attributes(topic)
				publish_topic(@topic) if !publish.nil?
				notice = publish.nil? ? "Topic has been successfully Updated." : "Topic is being published. It will take some time. Please check status after some time."
				if @topic.is_bookmark_video
					format.html{redirect_to edit_admin_topic_url(@topic), notice: notice}
				else
					format.html{redirect_to "#{admin_contents_url}#topics", notice: notice}
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
			notice = publish.nil? ? "Topic has been successfully Saved." : "Topic is being published. It will take some time. Please check status after some time."
			if @topic.is_bookmark_video
				redirect_to edit_admin_topic_url(@topic), notice: notice
			else
				redirect_to "#{admin_contents_url}#topics", notice: notice
			end
		else
			@courses = Course.all
			channel = Channel.find(@topic.channel_id)
			@channel_courses = channel.try(:courses) || []
			render "new"
		end
	end

	def publish_topic(topic)
		topic.update_attribute(:status, "InProcess")
		topic.upload_to_vimeo
	end
end
