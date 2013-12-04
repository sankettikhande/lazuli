class AddCourseIdToUserChannelSubscriptions < ActiveRecord::Migration
  def change
  	add_column :user_channel_subscriptions, :course_id, :integer if !column_exists? :user_channel_subscriptions, :course_id 
  end
end
