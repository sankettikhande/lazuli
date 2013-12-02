class ChannelCourse < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :channel
  belongs_to :course
end
