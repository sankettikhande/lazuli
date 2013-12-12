class ChannelCoursePermission < ActiveRecord::Base
	include Cacheable
  attr_accessible :channel_id, :course_id, :permission_watch, :permission_create, :permission_share
  belongs_to :course
  belongs_to :channel
end
