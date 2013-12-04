class AddDateFieldsToUserChannelSubscriptions < ActiveRecord::Migration
  def self.up
  	change_table :user_channel_subscriptions do |t|
	  	t.date :subscription_date if !column_exists? :user_channel_subscriptions, :subscription_date
	  	t.date :expiry_date if !column_exists? :user_channel_subscriptions, :expiry_date
	  end	
  end

  def self.down
  	change_table :user_channel_subscriptions do |t|
	  	t.remove :subscription_date if column_exists? :user_channel_subscriptions, :subscription_date
	  	t.remove :expiry_date if column_exists? :user_channel_subscriptions, :expiry_date
	  end	
  end	
end
