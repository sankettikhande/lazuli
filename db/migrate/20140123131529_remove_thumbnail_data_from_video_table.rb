class RemoveThumbnailDataFromVideoTable < ActiveRecord::Migration
  def change
  	remove_column :videos, :thumbnail_data
  end
end
