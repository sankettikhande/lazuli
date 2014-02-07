class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :view_count, :default => 1
      t.timestamps
    end

    add_index :histories, :video_id
    add_index :histories, :user_id
    add_index :histories, :view_count
  end
end
