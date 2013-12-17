class CourseSubscription < ActiveRecord::Base
  attr_accessible :course_id, :subscription_id
  belongs_to :course
  belongs_to :subscription
end
