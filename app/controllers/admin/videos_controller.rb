class Admin::VideosController < AdminController

	def edit
		@video = Video.find(params[:id])
		redirect_to "/admin/topics/#{@video.topic_id}/edit"
	end

	def destroy
		@video = Video.find(params[:id])
		@video.destroy
		respond_to do |format|
			format.html {redirect_to admin_contents_url}
		end
	end
end
