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

  task :update_statuses => :environment do
    Video.where(:status => "Publish").update_all(:status => 'Published')
    Topic.where(:status => "Publish").update_all(:status => 'Published')
  end

  task :update_vimeo_data => :environment do
    Video.where("vimeo_id IS NOT NULL").find_in_batches(:select => "vimeo_id") do |videos|
      videos.each do |video|
        video_obj = Video.find_by_vimeo_id(video.vimeo_id)
        video_obj.get_vimeo_info
      end
    end
  end
end
