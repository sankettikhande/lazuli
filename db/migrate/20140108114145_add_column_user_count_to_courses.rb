class AddColumnUserCountToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :user_count, :integer
  end
end
