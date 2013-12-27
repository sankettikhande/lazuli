class AddIsBookmarkVideoInTopics < ActiveRecord::Migration
  def change
  	add_column :topics, :is_bookmark_video, :boolean, :default => false
  	add_column :videos, :bookmark, :string
  end
end
