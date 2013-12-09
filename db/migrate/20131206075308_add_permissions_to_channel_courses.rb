class AddPermissionsToChannelCourses < ActiveRecord::Migration
  def change
  	add_column :channel_courses, :permission_watch, :boolean
  	add_column :channel_courses, :permission_create, :boolean
  	add_column :channel_courses, :permission_share, :boolean
  end
end
