class AddColumnPriceToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :price, :string
  end
end
