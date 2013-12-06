class UserChannelSubscription < ActiveRecord::Base
  attr_accessible :user_id, :channel_id, :subscription_id, :subscription_date, :expiry_date, :course_id, :permission_watch, :permission_create, :permission_share
  
  belongs_to :user
  belongs_to :subscription
  belongs_to :channel
  belongs_to :course

  validates_presence_of :channel_id, :subscription_id, :subscription_date, :expiry_date, :course_id
end
