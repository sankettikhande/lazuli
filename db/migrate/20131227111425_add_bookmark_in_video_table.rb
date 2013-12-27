class AddBookmarkInVideoTable < ActiveRecord::Migration
  def change
  	add_column :videos, :bookmark, :string
  end
end
