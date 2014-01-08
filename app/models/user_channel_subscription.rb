class UserChannelSubscription < ActiveRecord::Base
  attr_accessible :user_id, :channel_id, :subscription_id, :subscription_date, :expiry_date, :course_id, :permission_watch, :permission_create, :permission_share
  attr_accessor :_destroy
  attr_accessible :_destroy
  
  belongs_to :user
  belongs_to :subscription
  belongs_to :channel
  belongs_to :course

  #validates_presence_of :channel_id, :subscription_id, :subscription_date, :expiry_date, :course_id
  validates :user_id, :uniqueness => {:scope => [:channel_id, :course_id]}
  after_create :update_channel_user_count

  def update_channel_user_count
    channel.update_attribute(:user_count, UserChannelSubscription.where(:channel_id => 9).count(:course_id, :distinct => true))
  end

end
