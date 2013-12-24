class Admin::ContentsController < AdminController
	def index
		@videos = Video.order((params[:sort_column] || "title") + " " + (params[:direction] || "asc")).page(params[:page]).per(5)
		@courses = Course.order((params[:sort_column] || "name") + " " + (params[:direction] || "asc")).page(params[:page]).per(5)
		@topics = Topic.order((params[:sort_column] || "title") + " " + (params[:direction] || "asc")).page(params[:page]).per(5)
	end
end
