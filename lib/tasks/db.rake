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

  task :update_video_status => :environment do
    Video.where(:status => nil).update_all(:status => 'Saved')
  end

  task :update_topic_status => :environment do
    Topic.where(:status => nil).update_all(:status => 'Saved')
  end
	
  task :update_channel_ids => :environment do
    Course.find_each do |course|
      channel_id = Channel.where(:admin_user_id => course.channel_admin_user_id).pluck(:id)
      course.update_attribute(:channel_id, channel_id.join(",")) if course.channel_id.blank?
    end
  end

  task :update_user_count => :environment do
    Channel.find_each do |channel|
      channel.update_attribute(:user_count, UserChannelSubscription.where(:channel_id => channel.id).count(:user_id, :distinct => true))
      channel.courses.each do |course|
        course.update_attribute(:user_count, UserChannelSubscription.where(:channel_id => channel.id, :course_id => course.id).count(:user_id, :distinct => true))
      end
    end
  end

  task :set_course_admin_user_ids_null => :environment do
    Course.find_each do |course|
      user = User.find_by_id(course.course_admin_user_id)
      ucs = UserChannelSubscription.where(:user_id => user).pluck(:course_id)
      course.update_attribute(:course_admin_user_id, nil) unless user && ucs.include?(course.id)
    end
  end

  task :set_preset => :environment do
    include VimeoLib
    Video.find_each do |video|
      puts "#{video.vimeo_id} is updating"
      VimeoLib.video_embed.set_preset(video.vimeo_id, Settings.lazuli_preset_id) if video.vimeo_id
      puts "#{video.vimeo_id} is updated"
    end
  end

  task :set_default_price_for_subscriptions => :environment do
    CourseSubscription.find_each do |cs|
      cs.update_attribute(:subscription_price, 10) if cs.subscription_price.blank?
    end
  end

  task :set_trial_subscrioption => :environment do
    subscription = Subscription.find_by_name('Trial Subscription')
    puts "Subscription #{subscription.id} is updating"
    subscription.update_attribute(:is_trial_subscription, true)
    puts "Subscription #{subscription.id} is updated"
  end

  task :create_course_trainers => :environment do
    Course.find_each do |cs|
      cs.course_trainers.create if cs.course_trainers.blank?
    end
  end
end