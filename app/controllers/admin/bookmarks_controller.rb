class Admin::BookmarksController < AdminController
	def create_bulk
		@video = Video.find(params[:id])
		unique_bookmarks
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

	private
	def unique_bookmarks
		time_elements = params[:video][:bookmarks_attributes].map{ |a,b| b }.map{ |bookmark| bookmark[:time] if bookmark["_destroy"] == "false" }
		time_elements.size == time_elements.uniq.size ? true : @video.errors.add(:base, 'Bookmarks time has already been taken')
	end
end