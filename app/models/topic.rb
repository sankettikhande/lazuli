class Topic < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :course
end
