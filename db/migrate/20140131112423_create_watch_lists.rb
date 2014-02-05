class CreateWatchLists < ActiveRecord::Migration
  def change
    create_table :watch_lists do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :course_id
      t.timestamps
    end

    add_index :watch_lists, :video_id
    add_index :watch_lists, :course_id
    add_index :watch_lists, :user_id
  end
end
