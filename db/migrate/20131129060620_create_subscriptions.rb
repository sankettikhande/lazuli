class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.integer :days
      t.integer :months
      t.integer :years
      t.integer :calculated_days
      t.timestamps
    end
  end
end
