class CreateChannelCoursesPermissionsTable < ActiveRecord::Migration
  def change
  	create_table :channel_course_permissions do |t|
      t.integer :channel_id
      t.integer :course_id
      t.boolean :permission_watch
      t.boolean :permission_create
      t.boolean :permission_share

      t.timestamps
    end
  end
end
