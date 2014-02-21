class SubscriptionsController < ApplicationController
	before_filter :authenticate_user!

	def subscribe_course
		params[:course_subscription][:user_id] = current_user.id
		subscription_param = params[:course_subscription].except('subscription_id')
		@user_channel_subscription = UserChannelSubscription.where(subscription_param).first || UserChannelSubscription.new(params[:course_subscription])
		@user_channel_subscription.subscription_id = params[:course_subscription][:subscription_id]
		duration = "duration_#{@user_channel_subscription.subscription_id}".to_sym
		@user_channel_subscription.set_subscription_date_range(params[duration].to_i)
		@user_channel_subscription.save
		respond_to do |format|
			format.js { render :js => "window.location.href = ('#{request.referer}');", :notice => "You are successfully subscribed to the course."}
		end
	end

	def destroy
    @user_subscription = UserChannelSubscription.find_by_id_and_user_id(params[:id], current_user.id)
    @user_subscription.destroy if @user_subscription
    respond_to do |format|
			format.js {}
		end
  end

  def subscribe
  	@course = Course.find params[:id]
  end
end
