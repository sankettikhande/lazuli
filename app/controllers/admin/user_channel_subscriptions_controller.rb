class Admin::UserChannelSubscriptionsController < AdminController

	def edit
		@user_subscription = UserChannelSubscription.find(params[:id])
	end

	def update
		@user_subscription = UserChannelSubscription.find(params[:id])
		@user_subscription.update_attributes(params[:user_channel_subscription])
	end	

end
