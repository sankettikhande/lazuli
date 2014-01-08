class Admin::ContentsController < AdminController
	def index
		respond_to do |format|
      format.html { }
    end
	end

	def get_topics
		@topics = Topic.includes(:course).order((params[:sort_column] || "title") + " " + (params[:direction] || "asc")).page(params[:page])
		respond_to do |format|
      format.js { }
    end
	end

	def get_videos
		@videos = Video.includes({:topic => :course}, :tags).order((params[:sort_column] || "title") + " " + (params[:direction] || "asc")).page(params[:page])
		respond_to do |format|
      format.js { }
    end
	end

	def get_courses
		@courses = Course.includes(:channel_courses, :channel_course_permissions, :channels, :user_channel_subscriptions).order((params[:sort_column] || "name") + " " + (params[:direction] || "asc")).page(params[:page])
		respond_to do |format|
      format.js { }
    end
	end
end
