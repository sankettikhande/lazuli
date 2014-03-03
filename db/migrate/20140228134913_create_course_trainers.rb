class CreateCourseTrainers < ActiveRecord::Migration
  def change
    create_table :course_trainers do |t|
      t.string :name
      t.string :biography
      t.integer :course_id

      t.timestamps
    end
  end
end
