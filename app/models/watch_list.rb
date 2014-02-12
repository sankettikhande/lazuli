class WatchList < ActiveRecord::Base
  attr_accessible :video_id, :course_id, :user_id

  belongs_to :user
  belongs_to :video
  belongs_to :course

  validates_uniqueness_of :video_id, :scope => [:course_id, :user_id], :message => "^Video already exist in watch list"

  def self.get_video_ids_for(user)
    watch_list_video_ids = user.watch_lists.select("video_id").map(&:video_id)
  end

	def self.get_user_videos(user)
		watch_list = WatchList.get_video_ids_for(user)
		Video.find(watch_list, :include => {:topic => :course})
  end

  def self.get_video(user, video_id)
    find_by_user_id_and_video_id(user, video_id)
  end
end