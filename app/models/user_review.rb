class UserReview < ActiveRecord::Base
  attr_accessible :overall_course, :quality_of_audio_video, :quality_of_explanation, :course_structure, :accessibility, :value_of_money, :recommand_site, :suggestion, :feedback_email 
  VALID_RATINGS=['1','2','3','4','5']   
end
