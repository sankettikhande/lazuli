class Course < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :trainer_name, :trainer_biography, :image, 
                  :channel_course_permissions_attributes, :channel_courses_attributes, 
                  :course_subscriptions_attributes, :subscription_ids

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
                    :default_url => ":class/:style/missing.gif", 
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension",
                    :url => "/system/:class/:attachment/:id/:style/:basename.:extension"

  #ASSOCIATIONS
  has_many :channel_courses
  has_many :channels, :through => :channel_courses
  has_many :topics, :dependent => :destroy
  has_many :user_channel_subscriptions, :dependent => :destroy
  has_many :channel_course_permissions, :dependent => :destroy

  has_many :course_subscriptions, :dependent => :destroy
  has_many :subscriptions, :through => :course_subscriptions

  include Cacheable
  
  #VALIDATIONS
  validates_presence_of :name, :message => "^Course Name can't be blank"
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']
  validates_presence_of :subscription_ids, :message => "^Select atleast one Subscription"
  validate :course_name

  accepts_nested_attributes_for :channel_course_permissions, :allow_destroy => true
  accepts_nested_attributes_for :channel_courses, :allow_destroy => true
  accepts_nested_attributes_for :course_subscriptions, :reject_if => :all_blank, :allow_destroy => true
  #SCOPES
  after_save :set_channel_permission
  after_initialize :create_associations
  
  #INSTANCE METHODS
  def set_channel_permission
    self.channel_course_permissions.each do |permission|
      if !self.channel_courses.blank?
        permission.channel_id = self.channel.id
        permission.save
      end
    end
  end

  def channel
    channels.first
  end

  def course_name
    c_courses = channel_courses.first.channel.courses.to_a rescue []
    return if c_courses.blank?
    c_courses.delete(self)
    channel_course_names = c_courses.map(&:name)
    errors.add(:base, "Course name must be uniq") if channel_course_names.include? self.name
  end

  def name_for_form
    name.blank? ? "Course Details" : name
  end

  def users_for_course
    user_channel_subscriptions.blank? ? "-" : user_channel_subscriptions.count
  end

  private 
  def create_associations()
    self.channel_course_permissions.build if self.channel_course_permissions.size.zero?
  end

  #CLASS METHODS
end
