class Topic < ActiveRecord::Base
  attr_accessible :title, :description, :course_id, :channel_id, :videos_attributes
  belongs_to :course
  has_many :videos, :dependent => :destroy
  accepts_nested_attributes_for :videos, :allow_destroy => true

  validates :course_id, :presence => true
end
