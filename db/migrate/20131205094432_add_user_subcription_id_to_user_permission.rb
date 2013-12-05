class AddUserSubcriptionIdToUserPermission < ActiveRecord::Migration
  def change
  	add_column :user_permissions, :user_channel_subscription_id, :integer
  end
end
