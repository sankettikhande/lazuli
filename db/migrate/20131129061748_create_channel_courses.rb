class CreateChannelCourses < ActiveRecord::Migration
  def change
    create_table :channel_courses do |t|
      t.integer :channel_id
      t.integer :course_id
      t.timestamps
    end
    add_index :channel_courses, :channel_id
    add_index :channel_courses, :course_id
  end
end
