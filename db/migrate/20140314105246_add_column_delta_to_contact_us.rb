class AddColumnDeltaToContactUs < ActiveRecord::Migration
  def change
    add_column :contact_us, :delta, :boolean, :default => true, :null => false
    add_index  :contact_us, :delta
  end
end
