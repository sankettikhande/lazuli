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

	def sort_bookmarks(params)
		bookmarks_attributes = ActiveSupport::HashWithIndifferentAccess.new
		bookmarks_arr = params[:video][:bookmarks_attributes].map{ |x,y| y }.sort {|a,b| a['time']<=>b['time']}
		bookmarks_arr.each_with_index do |bookmark, index|
			params[:video][:bookmarks_attributes][index.to_s] = bookmark
		end
		ActiveSupport::HashWithIndifferentAccess.new(params)
	end
end