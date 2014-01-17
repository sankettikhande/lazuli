class Admin::BookmarksController < AdminController
	def create_bulk
		@video = Video.find(params[:id])
		@video.unique_bookmarks(params)
		@video.update_attributes(params[:video]) if @video.errors.blank?
		if @video.bookmarks.blank?
			@bookmark_videos = @video.bookmarks.build
			@bookmark_videos.time = "00:00:00"
		else
			@bookmark_videos = @video.bookmarks.order("bookmark_sec")
		end
		respond_to do |format|
      format.js
    end
	end

	def bookmark_video
		@video = Video.find(params[:id])
		if @video.bookmarks.blank?
			@bookmark_videos = @video.bookmarks.build
			@bookmark_videos.time = "00:00:00"
		else
			@bookmark_videos = @video.bookmarks.order("bookmark_sec")
		end
	end
end