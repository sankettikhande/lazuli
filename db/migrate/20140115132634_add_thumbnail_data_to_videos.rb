class AddThumbnailDataToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :thumbnail_data, :text
  end
end
