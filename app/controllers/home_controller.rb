class HomeController < ApplicationController
  def index
  	@videos = Video.where(:status => "Published").order('created_at').limit(12)
  	@courses = Course.last(4)
  end
end
