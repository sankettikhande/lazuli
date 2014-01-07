class AddColumnDeltaToUserChannelTopicAndVideo < ActiveRecord::Migration
  def change
    add_column :channels, :delta, :boolean, :default => true, :null => false
    add_column :topics,   :delta, :boolean, :default => true, :null => false
    add_column :videos,   :delta, :boolean, :default => true, :null => false
    add_column :users,    :delta, :boolean, :default => true, :null => false

    add_index  :channels, :delta
    add_index  :topics,   :delta
    add_index  :videos,   :delta
    add_index  :users,    :delta
  end
end
