class SetTrialSubscriptionDefaultPrice < ActiveRecord::Migration
  def up
  	subscription = Subscription.find_by_name("Trial Subscription")
  	if subscription
  		subscription.is_trial_subscription = true
  		subscription.price = "Free"
  		subscription.save
  	end	
  end

  def down
  end
end
