class AddDeltaColumnToFavouritesAndWatchLists < ActiveRecord::Migration
  def change
  	add_column :favourites, :delta, :boolean, :default => true, :null => false
  	add_column :watch_lists, :delta, :boolean, :default => true, :null => false
    add_index  :favourites, :delta
    add_index  :watch_lists, :delta
  end
end
