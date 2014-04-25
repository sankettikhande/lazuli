class AddThumbnailControlToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :thumbnail_control, :boolean, :default => false, :null => false
  end
end
