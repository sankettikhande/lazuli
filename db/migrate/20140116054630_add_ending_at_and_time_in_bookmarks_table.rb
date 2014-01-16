class AddEndingAtAndTimeInBookmarksTable < ActiveRecord::Migration
  def change
  	add_column :bookmarks, :ending_at, :string
  	add_column :bookmarks, :bookmark_sec, :float
  	add_index :bookmarks, :bookmark_sec
  end
end
