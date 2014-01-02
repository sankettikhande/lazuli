class RemoveTopicsHasnotChannelid < ActiveRecord::Migration
  def change
  	Topic.destroy_all(['channel_id is ? or course_id is ?', nil, nil])
  end
end
