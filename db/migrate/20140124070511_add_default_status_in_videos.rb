class AddDefaultStatusInVideos < ActiveRecord::Migration
  def up
  	change_column_default :videos, :status, "Saved"
  	Video.where(:status => nil).update_all(:status => 'Saved')
  end

  def down
  	change_column_default :videos, :status, nil
  	Video.where(:status => 'Saved').update_all(:status => nil)
  end
end
