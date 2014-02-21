class UserReview < ActiveRecord::Base
  attr_accessible :overall_course, :quality_of_audio_video, :quality_of_explanation, :course_structure, :accessibility, :value_of_money, :recommand_site, :suggestion, :feedback_email 
  VALID_RATINGS=['1','2','3','4','5'] 
  validates :feedback_email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :unless => Proc.new {|c| c.feedback_email.blank?}
  before_validation :check_for_existence  

  private

    def check_for_existence
      count=0      
      self.attributes.each do |name, value|      	
      	if name.in?('overall_course', 'quality_of_audio_video', 'quality_of_explanation', 'course_structure', 'accessibility', 'value_of_money')
      	  count+=1 if value.nil?
        end        
      end
      errors.add(:base, 'At least give one rating.') if count ==6      
    end      
end
