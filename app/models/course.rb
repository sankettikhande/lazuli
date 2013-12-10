class Course < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :trainer_name, :trainer_biography, :image, :channel_course_permissions_attributes, :channel_courses_attributes

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png", :path => ":rails_root/public/images/courses/:id/:style/:basename.:extension"

  #ASSOCIATIONS
  has_many :channel_courses
  has_many :channels, :through => :channel_courses
  has_many :topics
  has_many :user_channel_subscriptions
  has_many :channel_course_permissions

  
  #VALIDATIONS
  validates :name, :presence => true
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']

  accepts_nested_attributes_for :channel_course_permissions, :allow_destroy => true
  accepts_nested_attributes_for :channel_courses, :allow_destroy => true
  #SCOPES
  after_save :set_channel_permission

  #INSTANCE METHODS
  def set_channel_permission
    self.channel_course_permissions.each do |permission|
      if self.channel_courses
        permission.channel_id = self.channel.id
        permission.save
      end
    end
  end

  def channel
    channels.first
  end

  #CLASS METHODS
end
