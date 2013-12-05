class AddCourseCountInChannels < ActiveRecord::Migration
  def self.up
    add_column :channels, :courses_count, :integer, :default => 0
  end

  def self.down
    remove_column :channels, :courses_count
  end
end
