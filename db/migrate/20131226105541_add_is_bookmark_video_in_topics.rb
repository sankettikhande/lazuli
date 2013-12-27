class AddIsBookmarkVideoInTopics < ActiveRecord::Migration
  def change
  	add_column :topics, :is_bookmark_video, :boolean, :default => false
  end
end
