class CreateUserChannelSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_channel_subscriptions do |t|
      t.integer :user_id
      t.integer :subscription_id
      t.integer :channel_id
      t.timestamps
    end
  end
end
