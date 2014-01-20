class UpdateCourseCountToChannels < ActiveRecord::Migration
  def up
  	Channel.all.each do |channel|
  		channel.update_attribute(:course_count, channel.courses.count)
  	end
  end

  def down
  end
end
