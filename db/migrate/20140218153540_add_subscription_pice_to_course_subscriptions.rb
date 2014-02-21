class AddSubscriptionPiceToCourseSubscriptions < ActiveRecord::Migration
  def change
  	add_column :course_subscriptions, :subscription_price, :string
  end
end
