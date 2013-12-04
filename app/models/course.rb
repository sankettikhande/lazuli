class Course < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :description, :trainer_name, :trainer_biography

  #ASSOCIATIONS
  has_many :channel_courses
  has_many :channels, :through => :channel_courses
  has_many :topics
  has_many :course_permissions

  #VALIDATIONS
  validates :name, :presence => true

  #SCOPES

  #INSTANCE METHODS

  #CLASS METHODS
end
