class Admin::BookmarksController < AdminController
	def bookmark
		@video = Video.find(params[:id])
		@video.bookmarks_from_params = params["bookmark"]
		bookmarks = @video.process_bookmark
		if bookmarks && @video.validate_bookmark(bookmarks) 
			@video.bookmarks = bookmarks
			@video.set_vimeo_description(@video.vimeo_id, @video.description_text) if @video.vimeo_id
		else
			@error = bookmarks.map{ |bookmark| bookmark.errors.full_messages }.flatten.join(',').html_safe
		end
		respond_to do |format|
      format.js
    end
	end
end