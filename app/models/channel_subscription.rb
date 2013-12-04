class ChannelSubscription < ActiveRecord::Base
  attr_accessible :channel_id, :subscription_id
  belongs_to :channel
  belongs_to :subscription
end
