class Bookmark < ActiveRecord::Base
  attr_accessible :time, :title, :description
  belongs_to :video

  validates_presence_of :title
  validates_presence_of :time
  validates :time, :format => { :with => /[0-9]+:[0-9]+/ }, :unless => Proc.new {|c| c.time.blank?}
end
