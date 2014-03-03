class CourseTrainer < ActiveRecord::Base
  attr_accessible :biography, :name

  belongs_to :course
end
