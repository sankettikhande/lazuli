class Favourite < ActiveRecord::Base

	@@favouritable_types = ["Course", "Topic", "Video"]

  belongs_to :favouritable, :polymorphic => true
  belongs_to :user

  attr_accessible :favouritable_id, :favouritable_type, :user_id
  cattr_accessor :favouritable_types

  validates :favouritable_type, :inclusion => {:in => self.favouritable_types, :message => "should be either of ('Course', 'Topic', 'Video')"}

  scope :videos, where(:favouritable_type => "Video")

  ## retuns all video_ids for a particular user in favourite list
  def self.get_video_ids_for(user)
    favourite_video_ids = user.favourites.videos.select("favouritable_id").map(&:favouritable_id)
  end

  ## retuns all videos for a particular user in favourite list
  def self.get_user_videos(user)
    favourite_video_ids = Favourite.get_video_ids_for(user)
    Video.find(favourite_video_ids, :include => {:topic => :course})
  end

  def self.get_video(user, video_id, type="Video")
    find_by_favouritable_id_and_user_id_and_favouritable_type(video_id, user.id, type)
  end
end
