class AddColumnUserCountToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :user_count, :integer
  end
end
