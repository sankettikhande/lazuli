class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
    	t.string :title
    	t.string :favouritable_type
    	t.integer :favouritable_id
    	t.integer :user_id
      t.timestamps
    end

    add_index :favourites, :favouritable_type
    add_index :favourites, :favouritable_id
    add_index :favourites, :user_id
  end
end
