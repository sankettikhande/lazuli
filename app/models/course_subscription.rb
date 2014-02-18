class CourseSubscription < ActiveRecord::Base
  attr_accessible :course_id, :subscription_id, :subscription_price
  belongs_to :course
  belongs_to :subscription

  validates_uniqueness_of :subscription_id, :scope => :course_id

  include Cacheable
end
