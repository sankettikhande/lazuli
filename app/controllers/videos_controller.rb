class VideosController < ApplicationController
	before_filter :authenticate_user!
	before_filter :load_data, :only => [:tag_videos, :tag_search]

	def tag_videos
		@videos = Video.sphinx_search(params, current_user)
		respond_to do |format|
			format.html {}
			format.js { render 'videos/tag_search'}
		end
	end

	def tag_search
		@videos = Video.sphinx_search(params, current_user)
	end

	private
	
	def load_data
		page = (params[:page] || 1).to_i - 1
		params[:sSearch] = (params[:sSearch] || params[:search])
		params[:iDisplayLength] = 10
		params[:iDisplayStart] = params[:iDisplayLength] * page
	end
end
