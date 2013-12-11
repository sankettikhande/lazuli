class AddActualNameToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :actual_name, :string
  end
end
