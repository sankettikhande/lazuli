class AddPaymentStatusToUserChannelSubscriptions < ActiveRecord::Migration
  def change
  	add_column :user_channel_subscriptions, :payment_status, :string
  	add_column :user_channel_subscriptions, :amount_received, :string
  end
end
