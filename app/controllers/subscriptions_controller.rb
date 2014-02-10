class SubscriptionsController < ApplicationController
	before_filter :authenticate_user!

	def subscribe_course
		subscription_param = params[:course_subscription].except('subscription_id')
		@user_channel_subscription = UserChannelSubscription.where(subscription_param).first || UserChannelSubscription.new(params[:course_subscription])
		@user_channel_subscription.subscription_id = params[:course_subscription][:subscription_id]
		duration = "duration_#{@user_channel_subscription.subscription_id}".to_sym
		@user_channel_subscription.set_subscription_date_range(params[duration].to_i)
		@user_channel_subscription.save
	end
end
