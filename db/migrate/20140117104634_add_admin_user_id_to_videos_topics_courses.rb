class AddAdminUserIdToVideosTopicsCourses < ActiveRecord::Migration
  def change
  	add_column :topics, :channel_admin_user_id, :integer
  	add_column :topics, :course_admin_user_id, :integer
  	add_column :videos, :channel_admin_user_id, :integer
  	add_column :videos, :course_admin_user_id, :integer
  	add_column :courses, :channel_admin_user_id, :integer
  	add_column :courses, :course_admin_user_id, :integer
  end
end
