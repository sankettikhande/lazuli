class Topic < ActiveRecord::Base
  attr_accessible :title, :description, :course_id, :channel_id, :videos_attributes, :vimeo_album_id
  belongs_to :course
  has_many :videos, :dependent => :destroy
  accepts_nested_attributes_for :videos, :allow_destroy => true

  include Cacheable

  validates :course_id, :presence => true
  validates_presence_of :title ,:message => "^Topic can't be blank"
  validates_uniqueness_of :title, :scope => [:course_id, :channel_id]
  validate :check_uniqueness_of_title

   def check_uniqueness_of_title
    video_titles = videos.map(&:title)
    if(video_titles.length != video_titles.uniq.length)
      errors.add(:base, 'Video title must be unique')
    end 
  end
end

def add_to_vimeo_album
	vimeo_ids = self.videos.map {|v| v.vimeo_id if !v.vimeo_id.blank?}
	videos = vimeo_ids.join(",")
	album = VimeoLib.album.create(self.title, videos.first, {:description => self.description, :videos => videos})
	self.vimeo_album_id = album["album"].first["id"]
end

def delete_album
	VimeoLib.album.delete(self.vimeo_album_id)
end