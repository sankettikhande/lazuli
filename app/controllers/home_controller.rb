class HomeController < ApplicationController
  def index
  	@videos = Video.published.order('created_at').limit(Settings.data_count.latest_video)
  	@courses = Course.last(Settings.data_count.courses)
  end
end
