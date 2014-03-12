class VideosController < ApplicationController
	before_filter :authenticate_user!

	def tag_videos
		@videos = Video.search(:conditions => sphinx_condition(params[:search_tag])).page(params[:page]).per(15)
		respond_to do |format|
			format.html {}
			format.js { render 'videos/tag_search'}
		end
	end

	def tag_search
		@videos = Video.search(:conditions => sphinx_condition(params[:search])).page(params[:page]).per(15)
	end

	private

	def sphinx_condition(tags)
		public_condition = {:channel_type => "Public",:status => 'Published'}
		tags.blank? ? public_condition : public_condition.deep_merge!({:tags => tags})
	end
end
