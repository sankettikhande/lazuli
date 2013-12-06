class UserChannelSubscription < ActiveRecord::Base
  attr_accessible :user_id, :channel_id, :subscription_id, :subscription_date, :expiry_date, :course_id
  attr_accessible :user_permission_attributes
  belongs_to :user
  belongs_to :subscription
  belongs_to :channel
  has_one :user_permission, :dependent => :destroy
  accepts_nested_attributes_for :user_permission

  validates_presence_of :channel_id, :subscription_id, :subscription_date, :expiry_date, :course_id
end
