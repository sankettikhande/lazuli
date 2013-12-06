class ChannelCourse < ActiveRecord::Base
  attr_accessible :channel_id, :course_id
  belongs_to :channel
  belongs_to :course, :counter_cache => "channels_count"
end
