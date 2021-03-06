class CourseSubscription < ActiveRecord::Base
  attr_accessible :course_id, :subscription_id, :subscription_price
  belongs_to :course
  belongs_to :subscription

  validates_presence_of :subscription_price, :message => '^Please enter price for selected subscriptions.', :if => :subscription_id?
  validates_uniqueness_of :subscription_id, :scope => :course_id
  validates_numericality_of :subscription_price, :message => "^Please enter numeric value for subscription price.", :if => Proc.new { |s| !s.subscription.is_trial_subscription? }

  before_destroy :check_course_subscription

  include Cacheable
 
  def check_course_subscription
  	unless CourseSubscription.where(:course_id => self.course_id).count > 1
  		self.course.errors.add(:base, "Atleast one course subscription must be present.")
  		return false
  	end
  end

end
