class ChannelCoursePermission < ActiveRecord::Base
  attr_accessible :channel_id, :course_id, :permission_watch, :permission_create, :permission_share
  belongs_to :course
  belongs_to :channel
end
