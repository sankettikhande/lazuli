class AddViewedColumnToContactUs < ActiveRecord::Migration
  def change
  	add_column :contact_us, :viewed, :boolean, :default => false
  end
end
