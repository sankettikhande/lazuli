class AddThumbnailsToFavourites < ActiveRecord::Migration
  def change
  	add_column :favourites, :thumbnail, :text
  end
end
