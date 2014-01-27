class AddChannelIdToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :channel_id, :integer
  	add_index :courses, :channel_id
  end
end
