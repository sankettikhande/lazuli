class ChannelCourse < ActiveRecord::Base
  attr_accessible :channel_id, :course_id
  belongs_to :channel
  belongs_to :course

  validates_presence_of :channel_id, :message => "^Channel Name can't be blank"
end
