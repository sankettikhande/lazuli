class AddPermissionWatchDefaultValue < ActiveRecord::Migration
	def change
		change_column :user_channel_subscriptions, :permission_watch, :boolean, :default => true
	end
end
