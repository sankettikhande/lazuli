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
		filter_options, sql_options = {}, {}
		params[:search] = params[:search].gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
		options = {:star => true}
		filter_options.merge!(:conditions => {:status => "published"})
		# sql_options.merge!(:sql => {:include => [:channel, :topics]})
		sort_options = {:sort_mode =>  :extended, :order => :custom_model_sort}
		options.merge!(filter_options).merge!(sql_options).merge!(:classes => [Course, Topic, Video]).merge!(sort_options)
		@results = ThinkingSphinx.search(params[:search], options).page(params[:page]).per(20)

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

	def courses
		@courses = Course.public_courses params
		respond_to do |format|
	    format.json { render 'courses/search'}
	  end
	end
end
