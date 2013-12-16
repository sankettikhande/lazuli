class AddSubcriptionsRecords < ActiveRecord::Migration
  def up
  	Subscription.create(:name => 'Trial Subscription', :days => 30)
  	Subscription.create(:name => 'Half Yearly Subscription', :months => 6)
  	Subscription.create(:name => 'Yearly Subscription', :years => 1)
  	Subscription.create(:name => 'Two Year Subscription', :years => 2)		
  end

  def down
  end
end
