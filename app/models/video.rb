class Video < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :title, :description, :summary, :trial, :demo, :sequence_number
  belongs_to :topic
end
