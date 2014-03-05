class CreateContactUs < ActiveRecord::Migration
  def change
    create_table :contact_us do |t|
    	t.string :name
    	t.string :email
    	t.string :subject
    	t.string :message
    	t.integer :user_id
        t.timestamps
    end
  end
end
