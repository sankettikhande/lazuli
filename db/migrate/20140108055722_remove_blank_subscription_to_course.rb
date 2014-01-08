class RemoveBlankSubscriptionToCourse < ActiveRecord::Migration
  def change
	 	Course.all.each do |course|
	 	 	if(course.subscription_ids.blank?)
		 		course.destroy
		 	end
	 	end
	end
end
