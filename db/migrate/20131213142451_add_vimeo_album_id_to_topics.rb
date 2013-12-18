class AddVimeoAlbumIdToTopics < ActiveRecord::Migration
  def change
  	add_column  :topics , :vimeo_album_id, :integer
  end
end
