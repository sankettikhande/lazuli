class ChannelSubscription < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :channel
  belongs_to :subscription
end
