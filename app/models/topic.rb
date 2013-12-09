class Topic < ActiveRecord::Base
  attr_accessible :title, :description, :course_id, :channel_id, :image, :videos_attributes
  belongs_to :course
  has_many :videos
  accepts_nested_attributes_for :videos
end
