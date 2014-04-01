class SharedController < ApplicationController
	before_filter :authenticate_user!

	def index
		klass = controller_name.classify
		@videos = klass.constantize.get_user_videos(current_user)
		@deleted_videos = klass.constantize.get_user_deleted_videos(current_user)
	end

	def search
		@videos = []
		klass = controller_name.classify
		video_ids = klass.constantize.get_video_ids_for(current_user)
		@videos = Video.sphinx_search(params, current_user, video_ids) unless video_ids.blank?
  end

  def destroy
  	klass = controller_name.classify
  	video = klass.constantize.get_video(current_user, params[:id])
  	video.destroy if video
		@videos = klass.constantize.get_user_videos(current_user)
		@deleted_videos = klass.constantize.get_user_deleted_videos(current_user)
		respond_to do |format|
			format.js {render '/shared/destroy'}
		end
  end
end
