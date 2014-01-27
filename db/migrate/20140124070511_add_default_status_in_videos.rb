class AddDefaultStatusInVideos < ActiveRecord::Migration
  def up
  	change_column_default :videos, :status, "Saved"
  end

  def down
  	change_column_default :videos, :status, nil
  end
end
