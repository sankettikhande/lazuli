class HomeController < ApplicationController
  def index
  	@videos = Video.where(:status => "Publish").order('created_at').limit(12)
  	@courses = Course.last(4)
  end
end
