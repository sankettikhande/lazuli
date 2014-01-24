class AddDefaultStatusInTopics < ActiveRecord::Migration
  def up
  	change_column_default :topics, :status, "Saved"
  end
  
  def down
  	change_column_default :topics, :status, nil
  end
end
