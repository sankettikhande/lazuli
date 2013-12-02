class CreateChannelSubscriptions < ActiveRecord::Migration
  def change
    create_table :channel_subscriptions do |t|
      t.integer :channel_id
      t.integer :subscription_id
      t.timestamps
    end
    add_index :channel_subscriptions, :channel_id
    add_index :channel_subscriptions, :subscription_id
  end
end
