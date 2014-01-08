class AddPasswordColumnToTopics < ActiveRecord::Migration
  def change
  	add_column :topics, :password , :string
  end
end
