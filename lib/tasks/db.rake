namespace :db do
  desc "Update course_count"
  task :update_course_count => :environment do
  	Channel.find_each do |channel|
  		Channel.reset_counters channel.id, :courses
  	end
  end
end
