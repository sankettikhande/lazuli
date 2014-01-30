class SubscriptionsController < ApplicationController
	before_filter :authenticate_user!

	def subscribe_course
		subscription = init_user_subscription
		begin
			subscription.save
			flash[:success] = "You are successfully subscribed to the course."			
		rescue Exception => e
			flash[:error] = "Failed to subscribe to the course"
		end
		redirect_to course_url(:id => params[:id], :video_id => params[:video_id])
	end

	private
	
	def init_user_subscription
		subscription = UserChannelSubscription.new(params[:course_subscription])
		sub_id = params[:course_subscription][:subscription_id]
		subscription.course_id = params[:id]
		subscription.user_id = current_user.id
		subscription.permission_watch = true
		subscription.subscription_date = Date.today
		duration = "duration_#{sub_id}".to_sym
		subscription.expiry_date = Date.today + params[duration].to_i.days
		subscription
	end
end
