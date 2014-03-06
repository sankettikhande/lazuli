class TopicsController < ApplicationController
  layout 'application'
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
	def search		
		course_topics_id= Course.cached_find(params[:course_id]).topics.published.map{|i| i.id}	
		@course_topics= Topic.sphinx_search(params, current_user, course_topics_id)		
	end
end
