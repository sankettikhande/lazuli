class Favourite < ActiveRecord::Base

	@@favouritable_types = ["Course", "Topic", "Video"]

  belongs_to :favouritable, :polymorphic => true
  belongs_to :user

  attr_accessible :favouritable_id, :favouritable_type, :user_id, :title, :thumbnail
  cattr_accessor :favouritable_types

  validates :favouritable_type, :inclusion => {:in => self.favouritable_types, :message => "should be either of ('Course', 'Topic', 'Video')"}

  scope :videos, where(:favouritable_type => "Video")

  ## retuns all video_ids for a particular user in favourite list
  def self.get_video_ids_for(user)
    favourite_video_ids = user.favourites.videos.select("favouritable_id").map(&:favouritable_id)
  end

  def self.available_video_ids(user)
    favourite_video_ids = Favourite.get_video_ids_for(user)
    Video.where(:id => favourite_video_ids).pluck(:id)
  end
  ## retuns all videos for a particular user in favourite list
  def self.get_user_videos(user)
    Video.find(self.available_video_ids(user), :include => {:topic => :course})
  end

  def self.get_user_deleted_videos(user)
    user.favourites.videos - Favourite.where(:favouritable_id => self.available_video_ids(user), :user_id => user.id)
  end

  def self.get_video(user, video_id, type="Video")
    find_by_favouritable_id_and_user_id_and_favouritable_type(video_id, user.id, type)
  end

  def self.search_user_deleted_videos(query,current_user, ids)
    query_string = query.gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
    search_string = "@title #{query_string}*"
    options = {:conditions => {:user_id => current_user.id}, :with => {:id => ids}}
    Favourite.search(search_string, options)
  end
end
