class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :video_id
      t.string :time
      t.string :title
      t.text :description
      t.timestamps
    end
    add_index :bookmarks, :video_id
    add_index :bookmarks, :title
  end
end
