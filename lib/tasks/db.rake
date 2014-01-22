namespace :db do
  desc "Update course_count"
  task :update_course_count => :environment do
  	Channel.find_each do |channel|
  		Channel.reset_counters channel.id, :courses
  	end
  end

  task :remove_nullify_courses => :environment do
  	channel_courses_ids = []
	  ChannelCourse.find_in_batches do |channel_courses|
	  	channel_courses_ids = channel_courses_ids + channel_courses.map(&:course_id)
	  end
	  courses_ids = []
	  Course.find_in_batches do |courses|
	  	courses_ids = courses_ids + courses.map(&:id)
	  end
	  (courses_ids - channel_courses_ids).each do |id|
	  	Course.find_by_id(id).destroy
	  end
  end
end
