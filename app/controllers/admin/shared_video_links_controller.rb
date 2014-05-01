class Admin::SharedVideoLinksController < AdminController
	def index
		UserShareVideo.where(:user_id => current_user.id)
  end

  def search
    @user_share_videos = UserShareVideo.sphinx_search(params, current_user)   
  end

  def destroy
  	@user_share_video = UserShareVideo.find(params[:id])
  	@user_share_video.destroy
  	respond_to do |format|
			format.html {redirect_to admin_shared_video_links_url}
		end
  end
end