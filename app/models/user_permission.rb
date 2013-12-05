class UserPermission < ActiveRecord::Base
  attr_accessible :channel_id, :course_id, :produce, :share, :user_id, :watch, :user_channel_subscription_id

  belongs_to :user
  belongs_to :channel
  belongs_to :course
  belongs_to :user_channel_subscription
end
