class AddAsLeadToCourseTrainers < ActiveRecord::Migration
  def change
  	add_column :course_trainers, :as_lead, :boolean, :default => false 
  end
end
