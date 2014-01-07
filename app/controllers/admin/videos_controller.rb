class Admin::VideosController < AdminController

	def edit
		@video = Video.find(params[:id])
		redirect_to "/admin/topics/#{@video.topic_id}/edit"
	end

	def destroy
		@video = Video.find(params[:id])
		VimeoLib.video.delete(@video.vimeo_id) if @video.vimeo_id.present?
		@video.destroy
		respond_to do |format|
			format.html {redirect_to admin_contents_url}
		end
	end

	def upload
		@video = Video.find(params[:id])
		respond_to do |format|
			if @video.clip.present?
				@video.upload_single_video
				format.html {redirect_to admin_contents_url ,:notice =>"Video successfully uploaded"}
			else
				format.html {redirect_to admin_contents_url, :notice => "Video file not added"}
			end
		end
	end
end
