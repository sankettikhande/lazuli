class AddUserCourseCountDefaultsValue < ActiveRecord::Migration
  def up
  	change_column :channels, :user_count, :integer, :default => 0
  	change_column :channels, :course_count, :integer, :default => 0
  	change_column :courses, :user_count, :integer, :default => 0
  end

  def down
  end
end