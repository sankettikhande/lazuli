class UpdateRolesTypeToRoles < ActiveRecord::Migration
  def up
  	Role.create(:name => 'channel_admin') if Role.find_by_name('channel_admin').blank?
  	Role.create(:name => 'course_admin') if Role.find_by_name('course_admin').blank?
  end

  def down
  end
end
