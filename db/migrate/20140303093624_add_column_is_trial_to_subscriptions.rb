class AddColumnIsTrialToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :is_trial_subscription, :boolean, :default => false
  end
end
