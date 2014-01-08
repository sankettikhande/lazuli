class AddPasswordColumnToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :password , :string
  end
end
