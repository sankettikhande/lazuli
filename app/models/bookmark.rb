class Bookmark < ActiveRecord::Base
  attr_accessible :time, :title, :description
  belongs_to :video

  validates_presence_of :title
end
