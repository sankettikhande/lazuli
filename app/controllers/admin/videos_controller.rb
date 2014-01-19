class Admin::VideosController < AdminController
	load_and_authorize_resource
	rescue_from CanCan::AccessDenied do |exception|
	  redirect_to root_url, :alert => exception.message
	end
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
				@video.update_attribute(:status, "InProcess")
				@video.upload_single_video
				format.html {redirect_to admin_contents_url ,:notice =>"Video is being published. It will take some time. Please check status after some time."}
			else
				format.html {redirect_to admin_contents_url, :notice => "Video file not added"}
			end
		end
	end

	def search
		@videos = Video.sphinx_search(params, current_user)
	end
end
