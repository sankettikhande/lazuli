class HomeController < ApplicationController
  def index
  	@videos = Video.last(12)
  end
end
