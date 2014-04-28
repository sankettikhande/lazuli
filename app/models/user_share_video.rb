class UserShareVideo < ActiveRecord::Base
  attr_accessible :user_id, :video_id, :course_id, :starts_on, :ends_on, :u_token, :topic_id, :title, :duration, :email, :no_of_allowable_views,
:no_of_time_viewed
	validates_presence_of :duration, :message => '^Days to allow cant be blank.'
	validates_presence_of :no_of_allowable_views, :message => '^No of views to allow cant be blank.'
  
  def self.token_validity?(token)
  	usv = UserShareVideo.find_by_u_token(token)
  	usv.ends_on > Date.today && usv.no_of_views_remaining > 0
  end

  def no_of_views_remaining
  	self.no_of_allowable_views - self.no_of_time_viewed
  end

end


