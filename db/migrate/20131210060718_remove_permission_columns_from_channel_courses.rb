class RemovePermissionColumnsFromChannelCourses < ActiveRecord::Migration
  def change
		remove_column :channel_courses, :permission_watch if column_exists? :channel_courses, :permission_watch
		remove_column :channel_courses, :permission_create if column_exists? :channel_courses, :permission_create
		remove_column :channel_courses, :permission_share if column_exists? :channel_courses, :permission_share
  end
end
