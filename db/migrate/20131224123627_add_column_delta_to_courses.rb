class AddColumnDeltaToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :delta, :boolean, :default => true, :null => false
    add_index  :courses, :delta
  end
end
