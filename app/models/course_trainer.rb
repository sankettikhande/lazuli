class CourseTrainer < ActiveRecord::Base
  attr_accessible :biography, :name, :as_lead
  validates_presence_of :name
  belongs_to :course
  scope :as_lead, where(:as_lead => true)
end
