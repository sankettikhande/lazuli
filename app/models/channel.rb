class Channel < ActiveRecord::Base
  attr_accessible :name, :contact_number, :email, :user_name, :channel_type, :company_name, :company_contact_name, :company_postal_address, :company_address, :company_description, :company_number, :admin_user_id, :created_by, :image, :courses_attributes
  # attr_accessible :courses_attributes

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png", :path => ":rails_root/public/images/channels/:id/:style/:basename.:extension"

  #ASSOCIATIONS
  has_many :channel_courses
  has_many :courses, :through => :channel_courses
  has_many :channel_subscriptions
  has_many :subscriptions, :through => :channel_subscriptions
  has_many :channel_course_permissions
  
  belongs_to :admin, :class_name => User, :foreign_key => :admin_user_id
  belongs_to :creator, :class_name => User, :foreign_key => :created_by

  #VALIDATIONS
  validates :name, :company_name, :company_number, :presence => true
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :presence => true
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']

  accepts_nested_attributes_for :courses

  #SCOPES
  after_save :set_channel_permission, :on => :create


  #INSTANCE METHODS
  def set_channel_permission
    self.courses.each do |course|
      course.channel_course_permissions.each do |permission|
        permission.channel_id = self.id
        permission.save
      end
    end
  end


  #CLASS METHODS
  
end
