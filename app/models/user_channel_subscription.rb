class UserChannelSubscription < ActiveRecord::Base
  attr_accessible :user_id, :channel_id, :subscription_id, :subscription_date, :expiry_date, :course_id, :permission_watch, :permission_create, :permission_share
  attr_accessor :_destroy
  attr_accessible :_destroy
  
  belongs_to :user
  belongs_to :subscription
  belongs_to :channel
  belongs_to :course

  include Cacheable

  validates_lengths_from_database :limit => {:string => 255, :text => 1023}
  validates_presence_of :subscription_id, :subscription_date, :expiry_date, :if => Proc.new{|f| f.permission_create.blank? || f.permission_create == false }
  validates_presence_of :channel_id, :course_id
  validates :user_id, :uniqueness => {:scope => [:channel_id, :course_id], :message => "^User has already subscribed to this course."}
  after_save :update_channel_user_count
  after_save :update_course_user_count
  after_save :update_course_admin, :if => :create_permission_disabled?
  after_destroy :update_user_count, :update_course_admin

  def update_channel_user_count
    channel.update_attribute(:user_count, UserChannelSubscription.where(:channel_id => channel_id).count(:user_id, :distinct => true))
  end

  def update_course_user_count
    course.update_attribute(:user_count, UserChannelSubscription.where(:channel_id => channel_id, :course_id => course_id).count(:user_id, :distinct => true))
  end

  def create_permission_disabled?
    permission_create_changed? && permission_create == false
  end

  def update_course_admin
    course.update_attribute(:course_admin_user_id, nil)
    u = User.find self.user_id
    u.remove_role "course_admin" if u.administrated_courses.blank?
  end

  def update_user_count
    channel.update_attribute(:user_count, channel.user_count - 1)
    course.update_attribute(:user_count, course.user_count - 1)
  end

  ## TODO  change the method to take duration from subscription table
  def set_subscription_date_range(duration)
    self.subscription_date = Date.today
    self.expiry_date = Date.today + duration.days
  end

  def self.user_subscribed_courses(user)
    where(:user_id => user.id).includes([:channel, :course])
  end

  def subscription_expired?
    return false if self.permission_create
    (self.expiry_date - self.subscription_date).to_i <= 0
  end

  def self.search_course_ids(user)
    where(:user_id => user.id).select('course_id').map{ |i| i.course_id}
  end

  def self.search_subscription(user, course_ids)
    self.where("user_id = ? and course_id in (?)", user.id, course_ids).includes([:channel, :course])
  end

  def course_permission_create
    course = self.course
    course.channel_course_permissions.first.permission_create && course.course_admin_user_id.blank?
  end
end
