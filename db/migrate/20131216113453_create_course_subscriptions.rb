class CreateCourseSubscriptions < ActiveRecord::Migration
  def change
  	drop_table :channel_subscriptions
    create_table :course_subscriptions do |t|
      t.integer :course_id
      t.integer :subscription_id
      t.timestamps
    end
    add_index :course_subscriptions, :course_id
    add_index :course_subscriptions, :subscription_id
  end
end
