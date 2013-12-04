class UserChannelSubscription < ActiveRecord::Base
  attr_accessible :user_id, :channel_id, :subscription_id, :subscription_date, :expiry_date
  belongs_to :user
  belongs_to :subscription
  belongs_to :channel
end
