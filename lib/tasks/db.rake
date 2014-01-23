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
  	ChannelCourse.find_in_batches(:select => "course_id") { |channel_courses| channel_courses_ids += channel_courses.map(&:course_id) }
  	Course.find_in_batches(:select => "id") { |courses| courses_ids += courses.map(&:id) }
	  (courses_ids - channel_courses_ids).each do |id|
	  	Course.find_by_id(id).destroy
	  end
  end

  task :update_channel_admin_user_ids => :environment do
    Channel.find_each do |channel|
      channel.courses.each do |course| 
        course.update_attribute(:channel_admin_user_id, channel.admin_user_id) if course.channel_admin_user_id.blank?
        course.topics.each do |topic|
          topic.update_attribute(:channel_admin_user_id, course.channel_admin_user_id) if topic.channel_admin_user_id.blank?
          topic.videos.each {|video| video.update_attribute(:channel_admin_user_id, topic.channel_admin_user_id) if video.channel_admin_user_id.blank?}
        end
      end
    end
  end

  task :update_course_admin_user_ids => :environment do
    Course.find_each do |course|
      course.topics.each do |topic|
        topic.update_attribute(:course_admin_user_id,course.course_admin_user_id) if topic.course_admin_user_id.blank?
        topic.videos.each {|video| video.update_attribute(:course_admin_user_id, topic.course_admin_user_id)}
      end
    end
  end
end
