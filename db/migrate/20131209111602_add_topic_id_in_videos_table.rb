class AddTopicIdInVideosTable < ActiveRecord::Migration
  def change
  	add_column :videos, :topic_id, :integer
  end
end
