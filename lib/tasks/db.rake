namespace :db do
  desc "Update course_count"
  task :update_course_count => :environment do
  	Channel.find_each do |channel|
  		Channel.reset_counters channel.id, :courses
  	end
  end

  task :remove_nullify_courses => :environment do
  	channel_courses_ids = []
  	courses_ids = []
  	ChannelCourse.find_in_batches { |channel_courses| channel_courses_ids += channel_courses.map(&:course_id) }
  	Course.find_in_batches { |courses| courses_ids += courses.map(&:id) }
	  (courses_ids - channel_courses_ids).each do |id|
	  	Course.find_by_id(id).destroy
	  end
  end
end
