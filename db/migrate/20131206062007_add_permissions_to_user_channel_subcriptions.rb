class AddPermissionsToUserChannelSubcriptions < ActiveRecord::Migration
  def change
  	add_column :user_channel_subscriptions, :permission_watch, :boolean
  	add_column :user_channel_subscriptions, :permission_create, :boolean
  	add_column :user_channel_subscriptions, :permission_share, :boolean
  end
end
