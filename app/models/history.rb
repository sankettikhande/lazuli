class History < ActiveRecord::Base
  attr_accessible :video_id, :view_count, :user_id

  belongs_to :user
  belongs_to :video

  before_update :update_count

  def update_count
    self.view_count = self.view_count + 1
  end

  def self.get_user_videos(user)
    histories_list = user.histories.select("video_id").map(&:video_id)
    Video.find(histories_list)
  end
end
