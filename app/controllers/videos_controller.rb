class VideosController < ApplicationController
	
	def tag_videos
		@videos = Video.search(:conditions => sphinx_condition(params[:search]))
	end

	def tag_search
		@videos = Video.search(:conditions => sphinx_condition(params[:search]))
	end

	private
	
	def sphinx_condition(tag)
		tag.blank? ? {:status => 'Published'} : { :tags => "#{tag}*", :status => 'Published' }
	end
end