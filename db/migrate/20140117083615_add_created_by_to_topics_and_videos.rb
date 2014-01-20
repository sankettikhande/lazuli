class AddCreatedByToTopicsAndVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :created_by, :integer
  	add_column :topics, :created_by, :integer
  end
end
