class CreateUserShareVideos < ActiveRecord::Migration
  def change
    create_table :user_share_videos do |t|
      t.string :title
      t.string :email
      t.integer :duration, :default => 30
      t.integer :no_of_allowable_views, :default => 10
    	t.integer :user_id
      t.integer :topic_id
      t.integer :video_id
      t.integer :course_id
      t.date :starts_on
      t.date :ends_on
      t.integer :no_of_time_viewed, :default => 0
      t.string :u_token
      t.timestamps
    end
  end
end
