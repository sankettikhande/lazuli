class WatchList < ActiveRecord::Base
  attr_accessible :video_id, :course_id, :user_id

  belongs_to :user
  belongs_to :video
  belongs_to :course

  validates_uniqueness_of :video_id, :scope => [:course_id, :user_id], :message => "^Video already exist in watch list"

	def self.get_user_videos(user)
		watch_list = user.watch_lists.select("video_id").map(&:video_id)
		Video.find(watch_list)
  end
end
