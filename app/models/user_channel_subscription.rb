class UserChannelSubscription < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :subscription
  belongs_to :channel
end
