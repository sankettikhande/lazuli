class SubscriptionsController < ApplicationController
	before_filter :authenticate_user!

	def subscribe_course
		@subscription = UserChannelSubscription.new(params[:course_subscription])
		sid = params[:course_subscription][:subscription_id]
		duration = "duration_#{sid}".to_sym
		@subscription.set_subscription_date_range(params[duration].to_i)
		@subscription.save
	end
end
