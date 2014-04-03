class WatchList < ActiveRecord::Base
  attr_accessible :video_id, :course_id, :user_id, :title, :thumbnail

  belongs_to :user
  belongs_to :video
  belongs_to :course

  validates_uniqueness_of :video_id, :scope => [:course_id, :user_id], :message => "^Video already exist in watch list"

  def self.get_video_ids_for(user)
    watch_list_video_ids = user.watch_lists.select("video_id").map(&:video_id)
  end

  def self.available_video_ids(user)
    watch_list_video_ids = WatchList.get_video_ids_for(user)
    Video.where(:id => watch_list_video_ids).pluck(:id)
  end

	def self.get_user_videos(user)
		Video.find(self.available_video_ids(user), :include => {:topic => :course})
  end

  def self.get_user_deleted_videos(user)
    user.watch_lists - WatchList.where(:video_id => self.available_video_ids(user), :user_id => user.id)
  end

  def self.get_video(user, video_id)
    find_by_user_id_and_video_id(user,video_id)
  end

  def self.search_user_deleted_videos(query,current_user,ids)
    query_string = query.gsub(/([_@#!%()\-=;><,{}\~\[\]\.\/\?\"\*\^\$\+\-]+)/, ' ')
    search_string = "@title #{query_string}*"
    options = {:conditions => {:user_id => current_user.id}, :with => {:id => ids}}
    WatchList.search(search_string, options)
  end
end
