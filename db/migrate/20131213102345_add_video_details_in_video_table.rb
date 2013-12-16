class AddVideoDetailsInVideoTable < ActiveRecord::Migration
  def change
  	add_column :videos, :vimeo_id, :integer
  	add_column :videos, :vimeo_url, :string
  	add_column :videos, :vimeo_data, :text
  end
end
