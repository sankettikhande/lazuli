class UpdateUserCountToChannel < ActiveRecord::Migration
  def up
  	Channel.all.each do |channel|
  		channel.update_attribute(:user_count, UserChannelSubscription.where(:channel_id => channel.id).count(:user_id, :distinct => true))
  	end
  end

  def down
  end
end
