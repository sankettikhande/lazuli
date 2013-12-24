class Admin::ContentsController < AdminController
	def index
		respond_to do |format|
      format.html { }
    end
	end

	def get_topics
		@topics = Topic.order((params[:sort_column] || "title") + " " + (params[:direction] || "asc")).page(params[:page])
		respond_to do |format|
      format.js { }
    end
	end

	def get_videos
		@videos = Video.order((params[:sort_column] || "title") + " " + (params[:direction] || "asc")).page(params[:page])
		respond_to do |format|
      format.js { }
    end
	end

	def get_courses
		@courses = Course.order((params[:sort_column] || "name") + " " + (params[:direction] || "asc")).page(params[:page])
		respond_to do |format|
      format.js { }
    end
	end
end
