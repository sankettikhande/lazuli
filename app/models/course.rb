class Course < ActiveRecord::Base
  # attr_accessible :title, :body
  #ASSOCIATIONS
  has_many :channel_courses
  has_many :channels, :through => :channel_courses
  has_many :topics

  #VALIDATIONS
  validates :name, :presence => true

  #SCOPES

  #INSTANCE METHODS

  #CLASS METHODS
end
