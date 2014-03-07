class CourseTrainer < ActiveRecord::Base
  attr_accessible :biography, :name, :as_lead

  belongs_to :course
end
