class AddChannelIdToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :channel_id, :integer
  end
end
