class Topic < ActiveRecord::Base
  attr_accessible :title, :description, :course_id, :channel_id
  belongs_to :course
  has_many :videos

  validates :course_id, :presence => true
end
