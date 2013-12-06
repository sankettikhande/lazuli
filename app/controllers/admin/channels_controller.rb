class Admin::ChannelsController < AdminController
  def index
    @channels = Channel.all
  end

  def new
  	@channel = Channel.new
    @channel.courses.build()
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

  def edit
    @channel = Channel.find(params[:id], :include => :courses)
    @channel.courses.build() if @channel.courses_count == 0
  end

  def update
    @channel = Channel.find_by_id(params[:id])
    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        format.html {redirect_to admin_channels_url}
      else
        format.html { render :action => "edit" }
      end 
    end 
  end

  def destroy
    channel = Channel.find_by_id(params[:id])
    channel.destroy
    respond_to do |format|
      format.html { redirect_to admin_channels_url}   
    end  
  end
end
