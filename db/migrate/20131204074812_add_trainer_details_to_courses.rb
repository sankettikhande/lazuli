class AddTrainerDetailsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :trainer_name, :string
    add_column :courses, :trainer_biography, :string
  end
end
