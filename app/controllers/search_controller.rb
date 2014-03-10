class SearchController < ApplicationController

	def subscriptions
		course_ids = UserChannelSubscription.search_course_ids(current_user)
		course_ids = Course.sphinx_search(params, current_user, course_ids).map { |i| i.id}
		@subscribed_courses = UserChannelSubscription.search_subscription(current_user, course_ids)
		respond_to do |format|
	    format.js { render 'subscriptions/search'}
	  end
	end

	def search
		@results = WideSearch.search_results(params[:search]).page(params[:page]).per(20)
		respond_to do |format|
			format.html { render 'home/search' }
		end
	end

	def channels
		@channels = Channel.sphinx_search(params, current_user, "public")
		respond_to do |format|
	    format.js { render 'channels/search'}
	  end
	end

	def suggestions
		@results = WideSearch.search_suggestions params
		respond_to do |format|
	    format.json { render 'home/suggestions'}
	  end
	end

	def courses
		@courses = Course.public_courses params
		respond_to do |format|
	    format.json { render 'courses/search'}
	  end
	end
end
