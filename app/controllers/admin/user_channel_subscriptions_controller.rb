class Admin::UserChannelSubscriptionsController < AdminController

	def edit
		@user_subscription = UserChannelSubscription.find(params[:id])
		@channel = @user_subscription.channel
		@course = @user_subscription.course
		@subscriptions = @course.subscriptions
	end

	def update
		@user_subscription = UserChannelSubscription.find(params[:id])
		@user_subscription.update_attributes(params[:user_channel_subscription])
	end	

	def destroy
		user_subscription = UserChannelSubscription.find(params[:id])
		user_subscription.destroy
		respond_to do |format|
			format.html { redirect_to request.referrer}
		end
	end

end
