module ChannelsHelper
	def add_image_title(objekt)
		objekt.image.present? ? "Change Logo" : "Add Logo"
	end

  def browse_course_subscriptions course
    if course.subscriptions.map(&:calculated_days).include?(365)
      subscriptions_id = course.subscriptions.where(:name => "Yearly Subscription").last.id
      course_price = number_to_currency(course.course_subscriptions.where(subscription_id: subscriptions_id).last.subscription_price)
      content_tag(:li, "<b>#{course_price} &nbsp;</b>yearly".html_safe, class: "one_yr_subscription" ) << content_tag(:li, "More options available", class: "more_options_avaliable" )
    end
  end
end