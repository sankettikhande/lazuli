class Admin::BookmarksController < AdminController
	def create_bulk
		@video = Video.find(params[:id])
		@video.update_attributes(params[:video])
		@video.bookmarks.build if @video.bookmarks.blank?
		respond_to do |format|
      format.js
    end
	end

	def bookmark_video
		@video = Video.find(params[:id])
		@video.bookmarks.build if @video.bookmarks.blank?
	end
end