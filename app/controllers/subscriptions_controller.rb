class SubscriptionsController < ApplicationController
	before_filter :authenticate_user!

	def confirm_payment_and_subscribe
		params[:user_id] = current_user.id
		subscription_param = params.slice('channel_id','course_id','subscription_id','user_id')
		@user_channel_subscription = UserChannelSubscription.where(subscription_param.except('subscription_id')).first || UserChannelSubscription.new(subscription_param)
		@user_channel_subscription.subscription_id = params[:subscription_id]
		duration = Subscription.cached_find(@user_channel_subscription.subscription_id).calculated_days
		@user_channel_subscription.set_subscription_date_range(duration)
		@user_channel_subscription.save
		@course_id = params[:course_id]
		respond_to do |format|
			# format.html { render :js => "window.location.href = ('#{request.referer}');", :notice => "You are successfully subscribed to the course."}
		format.html
		end
	end 

	def subscribe_course
		@params = params[:course_subscription]
		@course = Course.cached_find(params[:id])
		@course_subscription = @course.course_subscriptions.where(:subscription_id => @params[:subscription_id]).first
		respond_to do |format|
			format.js
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

  def notification
    #handle for old deals.
    if params[:item_number1] && !params[:item_number1].empty?
      #paypal sends an IPN even when the transaction is voided.
      if params[:payment_status] != 'Voided'
        @course = Course.find(params[:item_number1].to_i) rescue nil
        params = {:user_id=> current_user.id, :course_id => @course.id, :channel_id => @course.channel_id}
        user_channel_subscription = @course.user_channel_subscriptions.where(:user_id => current_user.id).first
        if user_channel_subscription
        	user_channel_subscription.build(:payment_status => params[:payment_status], :amount_received => params[:mc_gross_1] ).save
        else
        	user_channel_subscription = UserChannelSubscription.new(params)
        	user_channel_subscription.payment_status = params[:payment_status]
        	user_channel_subscription.amount_received = params[:mc_gross_1]
 					user_channel_subscription.save
        end
      end
    end
    render :nothing => true
  end
end
