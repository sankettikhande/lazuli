class RenameColumnsInPermissionsTable < ActiveRecord::Migration
  def change
		rename_column :user_permissions, :create, :produce
		rename_column :course_permissions, :create, :produce
  end
end
