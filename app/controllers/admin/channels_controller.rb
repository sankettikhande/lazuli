class Admin::ChannelsController < AdminController
  def index
    @channels = Channel.all
  end

  def new
  	@channel = Channel.new
    course = @channel.courses.build()
    course.channel_courses.build()
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
    if @channel.courses_count == 0
      course = @channel.courses.build()
      course.course_permissions.build()
    end 
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

  def get_channel
    if params[:id]
      @channel = Channel.find_by_id(params[:id])
      respond_to do |format|
        format.json{}
      end
    end
  end
end
