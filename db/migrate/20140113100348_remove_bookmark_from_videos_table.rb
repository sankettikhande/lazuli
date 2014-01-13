class RemoveBookmarkFromVideosTable < ActiveRecord::Migration
  def change
  	remove_column :videos, :bookmark if column_exists? :videos, :bookmark
  end
end
