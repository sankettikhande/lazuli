class CoursePermission < ActiveRecord::Base
  attr_accessible :channel_id, :course_id, :produce, :share, :watch
  belongs_to :course
  belongs_to :channel
end
