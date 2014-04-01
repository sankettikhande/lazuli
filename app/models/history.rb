class History < ActiveRecord::Base
  attr_accessible :video_id, :view_count, :user_id

  belongs_to :user
  belongs_to :video

  validates :video_id, :uniqueness => {:scope => :user_id}

  def self.get_video_ids_for(user)
    history_video_ids = user.histories.select("video_id").map(&:video_id)
  end

  def self.available_video_ids(user)
    history_video_ids = History.get_video_ids_for(user)
    Video.where(:id => history_video_ids).pluck(:id)
  end

  def self.get_user_videos(user)
    Video.find(self.available_video_ids(user), :include => {:topic => :course})
  end

  def self.get_user_deleted_videos(user)
    user.histories - History.where(:video_id => self.available_video_ids(user), :user_id => user.id)
  end

  def self.get_video(user, video_id)
    find_by_user_id_and_video_id(user, video_id)
  end
end
