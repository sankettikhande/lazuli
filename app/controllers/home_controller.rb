class HomeController < ApplicationController
  def index
  	@videos = Video.last(12)
  	@courses = Course.last(4)
  end
end
