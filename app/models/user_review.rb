class UserReview < ActiveRecord::Base
  attr_accessible :overall_course, :quality_of_audio_video, :quality_of_explanation, :course_structure, :accessibility, :value_of_money, :recommand_site, :suggestion, :feedback_email 
  @@valid_ratings=['1','2','3','4','5'] 
  validates :feedback_email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :unless => Proc.new {|c| c.feedback_email.blank?}
  before_validation :check_for_existence 

  cattr_accessor :valid_ratings

  private

    def check_for_existence
      reviews = [self.overall_course, self.quality_of_audio_video, self.quality_of_explanation, self.course_structure, self.accessibility, self.value_of_money].compact
      errors.add(:base, 'At least give one rating.') if reviews.blank?         

    end      
end
