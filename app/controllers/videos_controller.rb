class VideosController < ApplicationController
	before_filter :authenticate_user!

	def tag_search
		@videos = Video.search(:conditions => sphinx_condition(params[:search]))
	end

	def add_to_watch_list
		watchList = WatchList.new(:video_id => params[:id], :course_id => params[:course_id], :user_id => current_user.id)
		if watchList.save
			@alertClass = "success"
			@msg = "Video added to watch list"
		else
			@alertClass = "info"
			@msg = watchList.errors.full_messages.first
		end
		respond_to do |format|
			format.js {render '/favourites/create'}
		end
	end

	def remove_from_watch_list
		watchList = WatchList.where(:video_id => params[:id], :course_id => params[:course_id], :user_id => current_user.id).first
		if watchList
			watchList.destroy
			@alertClass = "success"
			@msg = "Video remove from watch list"
		end
		respond_to do |format|
			format.js {render '/favourites/destroy'}
		end
	end

	private
	
	def sphinx_condition(tag)
		tag.blank? ? {:status => 'Published'} : { :tags => "#{tag}*", :status => 'Published' }
	end
end
