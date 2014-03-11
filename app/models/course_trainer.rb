class CourseTrainer < ActiveRecord::Base
  attr_accessible :biography, :name, :as_lead

  validates :name, :presence => true

  belongs_to :course
  scope :as_lead, where(:as_lead => true)
end
