class UserChannelSubscription < ActiveRecord::Base
  attr_accessible :user_id, :channel_id, :subscription_id, :subscription_date, :expiry_date, :course_id, :permission_watch, :permission_create, :permission_share
  attr_accessor :_destroy
  attr_accessible :_destroy
  
  belongs_to :user
  belongs_to :subscription
  belongs_to :channel
  belongs_to :course

  include Cacheable

  validates_presence_of :subscription_id, :subscription_date, :expiry_date, :if => Proc.new{|f| f.permission_create.blank? || f.permission_create == false }
  validates_presence_of :channel_id, :course_id
  validates :user_id, :uniqueness => {:scope => [:channel_id, :course_id], :message => "^User has already subscribed to this course."}
  after_save :update_channel_user_count
  after_save :update_course_user_count
  after_save :update_course_admin, :if => :create_permission_disabled?
  after_destroy :update_user_count

  def update_channel_user_count
    channel.update_attribute(:user_count, UserChannelSubscription.where(:channel_id => channel_id).count(:user_id, :distinct => true))
  end

  def update_course_user_count
    course.update_attribute(:user_count, UserChannelSubscription.where(:channel_id => channel_id).count(:user_id, :distinct => true))
  end

  def create_permission_disabled?
    permission_create_changed? && permission_create == false
  end

  def update_course_admin
    course.update_attribute(:course_admin_user_id, nil)
  end

  def update_user_count
    channel.update_attribute(:user_count, channel.user_count - 1)
    course.update_attribute(:user_count, course.user_count - 1)
  end

  def set_subscription_date_range(duration)
    self.subscription_date = Date.today
    self.expiry_date = Date.today + duration.days
  end
end
