class Admin::ChannelsController < AdminController
  def index
    @channels = Channel.all
  end

  def new
  	@channel = Channel.new
  end	

  def create
  	@channel = Channel.new(params[:channel])
  	respond_to do |format|
  		if @channel.save
  			format.html {redirect_to admin_channels_url}
  		else
  			format.html { render :action => "new" }
  		end	
  	end	
  end	
end
