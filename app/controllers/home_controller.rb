class HomeController < ApplicationController
  def index
    if user_signed_in?
      @videos = Video.joins(topic: :channel).order("videos.id desc").where("topics.status = ? and videos.status = ? and channels.channel_type = ?", "Published", "Published", "Public").limit(Settings.data_count.latest_video)
      @subscribed_courses = UserChannelSubscription.user_subscribed_courses(current_user)
      @courses = Course.public_channel_courses(10) if @subscribed_courses.blank?
    else
      @topics =  Topic.published.joins(:channel).where("channels.channel_type = ?", "Public").not_bookmarked.order("id desc").first(3)
      @courses = Course.public_channel_courses(3)
      respond_to do |format|
        format.html{ render 'devise/sessions/new', :layout => 'devise' }
      end
    end
  end

  def browse_course
    @channels = Channel.sphinx_search(params, current_user, "public")
    respond_to do |format|
      format.html{}
      format.js{ render 'channels/search'}
    end
  end

  def about_us
  end

  def faqs
  end
  
  def our_partners
    @channels = Channel.sphinx_search(params, current_user, "public")
    respond_to do |format|
      format.html{}
      format.js{ render 'channels/search'}
    end
  end

  def privacy_policy
  end

  def term_conditions
  end
end
