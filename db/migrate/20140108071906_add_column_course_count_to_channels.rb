class AddColumnCourseCountToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :course_count, :integer
  end
end
