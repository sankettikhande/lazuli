class History < ActiveRecord::Base
  attr_accessible :video_id, :view_count, :user_id

  belongs_to :user
  belongs_to :video

  validates :video_id, :uniqueness => {:scope => :user_id}

  def self.get_user_videos(user)
    histories_list = user.histories.select("video_id").map(&:video_id)
    Video.find(histories_list)
  end
end
