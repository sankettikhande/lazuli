class Topic < ActiveRecord::Base
  attr_accessible :title, :description, :course_id, :channel_id, :videos_attributes
  belongs_to :course
  has_many :videos
  accepts_nested_attributes_for :videos
end
