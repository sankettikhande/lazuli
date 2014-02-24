class CreateUserReviews < ActiveRecord::Migration
  def change
    create_table :user_reviews do |t|
      t.float :overall_course
      t.float :quality_of_audio_video
      t.float :quality_of_explanation
      t.float :course_structure
      t.float :accessibility
      t.float :value_of_money
      t.boolean :recommand_site
      t.string :suggestion
      t.string :feedback_email
      t.timestamps
    end
  end
end
