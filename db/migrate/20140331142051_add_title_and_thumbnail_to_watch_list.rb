class AddTitleAndThumbnailToWatchList < ActiveRecord::Migration
  def change
  	add_column :watch_lists, :title , :text
  	add_column :watch_lists, :thumbnail, :text
  end
end
