class AddDefaultStatusInTopics < ActiveRecord::Migration
  def up
  	change_column_default :topics, :status, "Saved"
  	Topic.where(:status => nil).update_all(:status => 'Saved')
  end
  
  def down
  	change_column_default :topics, :status, nil
  	Topic.where(:status => 'Saved').update_all(:status => nil)
  end
end
