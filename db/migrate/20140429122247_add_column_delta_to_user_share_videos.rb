class AddColumnDeltaToUserShareVideos < ActiveRecord::Migration
  def change
  	add_column :user_share_videos, :video_title, :string
  	add_column :user_share_videos, :delta, :boolean, :default => true, :null => false
    add_index  :user_share_videos, :delta
  end
end
