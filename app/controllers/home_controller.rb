class HomeController < ApplicationController
  def index
  	@videos = Video.where(:status => "Published").order('created_at').limit(Settings.data_count.latest_video)
  	@courses = Course.last(Settings.data_count.courses)
  end
end
