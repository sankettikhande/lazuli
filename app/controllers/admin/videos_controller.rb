class Admin::VideosController < AdminController
	load_and_authorize_resource
	
	def edit
		@video = Video.cached_find(params[:id])
		redirect_to "/admin/topics/#{@video.topic_id}/edit"
	end

	def destroy
		@video = Video.cached_find(params[:id])
		VimeoLib.video.delete(@video.vimeo_id) if @video.vimeo_id.present?
		@video.destroy
		respond_to do |format|
			format.html {redirect_to admin_contents_url}
		end
	end

	def upload
		@video = Video.cached_find(params[:id])
		respond_to do |format|
			if @video.clip.present?
				@video.update_attribute(:status, "InProcess")
				@video.upload_single_video
				format.html {redirect_to admin_contents_url ,:success =>"Video is being published. It will take some time. Please check status after some time."}
			else
				format.html {redirect_to admin_contents_url, :alert => "Video file not added"}
			end
		end
	end

	def search
		@videos = Video.sphinx_search(params, current_user)
	end
end
