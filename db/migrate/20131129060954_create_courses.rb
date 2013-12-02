class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.integer :created_by
      t.timestamps
    end
    add_index :courses, :created_by
  end
end
