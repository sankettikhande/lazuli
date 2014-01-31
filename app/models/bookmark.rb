class Bookmark < ActiveRecord::Base
  attr_accessible :time, :title, :description, :bookmark_sec, :ending_at
  belongs_to :video
  before_save :update_bookmark

  include Cacheable

  validates :title, :time, :presence => true
  validates :time, :format => { :with => /[0-9]+:[0-9]+:[0-9]+/ }, :unless => Proc.new {|c| c.time.blank?}
  
  def update_bookmark
    bookmarks_time = self.time.split(":")
  	self.bookmark_sec = bookmarks_time.first.to_i * 3600 + bookmarks_time.second.to_i * 60 + bookmarks_time.third.to_i
  end

  def self.update_ending_at(video)
  	bookmarks = video.bookmarks.order("bookmark_sec")
  	bookmarks.each_with_index do |bookmark, index|
  		bookmark.ending_at = bookmarks[index + 1].time if index + 1 < bookmarks.count
  		bookmark.save
  	end
  end
end
