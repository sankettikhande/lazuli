class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
    	t.string :title
    	t.string :description
    	t.string :summary
    	t.boolean :trial
    	t.boolean :demo
    	t.integer :sequence_number
      t.timestamps
    end
  end
end
