class UserPermission < ActiveRecord::Base
  attr_accessible :channel_id, :course_id, :create, :share, :user_id, :watch

  belongs_to :user
  belongs_to :channel
  belongs_to :course
end
