class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
    	t.string :title
    	t.string :favouritable_type
    	t.integer :favouritable_id
    	t.integer :user_id
      t.timestamps
    end
  end
end
