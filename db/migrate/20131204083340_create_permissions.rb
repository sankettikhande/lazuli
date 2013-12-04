class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :channel_id
      t.integer :course_id
      t.integer :user_id
      t.boolean :watch
      t.boolean :create
      t.boolean :share

      t.timestamps
    end
  end
end
