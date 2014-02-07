class VideosController < ApplicationController
	before_filter :authenticate_user!

	def tag_search
		@videos = Video.search(:conditions => sphinx_condition(params[:search]))
	end

	private
	
	def sphinx_condition(tag)
		tag.blank? ? {:status => 'Published'} : { :tags => "#{tag}*", :status => 'Published' }
	end
end
