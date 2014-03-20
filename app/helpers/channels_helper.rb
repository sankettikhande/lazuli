module ChannelsHelper
	def add_image_title(objekt)
		objekt.image.present? ? "Change Logo" : "Add Logo"
	end

  def browse_course_subscriptions course
    if course.subscriptions.map(&:calculated_days).include?(365)
      subscriptions_id = course.subscriptions.where(:name => "Yearly Subscription").last.id
      course_price = number_to_currency(course.course_subscriptions.where(subscription_id: subscriptions_id).last.subscription_price)
      content_tag(:li, "1 Yr Subscriptions: #{course_price}", class: "one_yr_subscription" )
    end
  end
end