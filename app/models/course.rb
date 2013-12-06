class Course < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :trainer_name, :trainer_biography, :image, :course_permission_attributes, :channel_courses_attributes
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png", :path => ":rails_root/public/images/courses/:id/:style/:basename.:extension"
  #ASSOCIATIONS
  has_many :channel_courses
  has_many :channels, :through => :channel_courses
  has_many :topics
  has_one :course_permission

  accepts_nested_attributes_for :course_permission, :channel_courses

  #VALIDATIONS
  validates :name, :presence => true
  validates_attachment_size :image, :less_than => 3.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png','image/gif','image/jpg']

  #SCOPES

  #INSTANCE METHODS

  #CLASS METHODS
end
