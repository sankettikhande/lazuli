class SearchController < ApplicationController

	def subscriptions
		course_ids = UserChannelSubscription.search_course_ids(current_user)
		pp course_ids
		course_ids = Course.sphinx_search(params, current_user, course_ids).map { |i| i.id}
		pp course_ids
		@subscribed_courses = UserChannelSubscription.search_subscription(current_user, course_ids)
		respond_to do |format|
	    format.js { render 'subscriptions/search'}
	  end
	end

	def search
		filter_options, sql_options = {}, {}
		options = {:star => true, :per_page => 50}
		filter_options.merge!(:conditions => {:topic_status => "published"})
		sql_options.merge!(:sql => {:include => [:channel, :topics]})
		options.merge!(filter_options).merge!(sql_options)
		@courses = Course.search params[:search], options
		respond_to do |format|
			format.html { render 'home/search' }
		end
	end

end
