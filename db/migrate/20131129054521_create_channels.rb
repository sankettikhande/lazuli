class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.integer :admin_user_id
      t.integer :created_by
      t.timestamps
    end
    add_index :channels, :admin_user_id
  end
end
