class Admin::BookmarksController < AdminController
	def create_bulk
		@video = Video.find(params[:id])
		@video.update_attributes(params[:video])
		@video.bookmarks.build if @video.bookmarks.blank?
		@bookmark_videos = @video.bookmarks.order("bookmark_sec") if !@video.bookmarks.blank?
		respond_to do |format|
      format.js
    end
	end

	def bookmark_video
		@video = Video.find(params[:id])
		if @video.bookmarks.blank?
			@bookmark_videos = @video.bookmarks.build 
		else
			@bookmark_videos = @video.bookmarks.order("bookmark_sec")
		end
	end
end