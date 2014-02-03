class SubscriptionsController < ApplicationController
	before_filter :authenticate_user!

	def subscribe_course
		subscription = UserChannelSubscription.new(params[:course_subscription])
		sid = params[:course_subscription][:subscription_id]
		duration = "duration_#{sid}".to_sym
		subscription.set_subscription_date_range(params[duration].to_i)
		begin
			subscription.save
			flash[:success] = "You are successfully subscribed to the course."			
		rescue Exception => e
			flash[:error] = "Failed to subscribe to the course"
		end
		redirect_to course_videos_url(subscription.course_id, params[:video_id])
	end
end
