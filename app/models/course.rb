class Course < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :trainer_name, :trainer_biography
  attr_accessible :course_permission_attributes, :channel_courses_attributes
  #ASSOCIATIONS
  has_many :channel_courses
  has_many :channels, :through => :channel_courses
  has_many :topics
  has_one :course_permission

  accepts_nested_attributes_for :course_permission, :channel_courses

  #VALIDATIONS
  validates :name, :presence => true

  #SCOPES

  #INSTANCE METHODS

  #CLASS METHODS
end
