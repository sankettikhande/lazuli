class Admin::VideosController < AdminController

	def edit
		@video = Video.find_by_id(params[:id])
		redirect_to admin_topics_edit_url
	end
end
