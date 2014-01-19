class Admin::ChannelsController < AdminController
  def index
  end

  def new
    set_initialization
  	@channel = Channel.new
    course = @channel.courses.build()
    # @subscriptions.count.times do |i|
    #   course.course_subscriptions.build
    # end
  end

  def search
    @channels = Channel.sphinx_search(params, current_user)
  end

  def create
    set_initialization
  	@channel = Channel.new(params[:channel])
    respond_to do |format|
  		if @channel.save
  			format.html {redirect_to admin_channels_url}
        flash[:notice] = "Channel has successfully created"
  		else
  			format.html { render :action => "new" }
  		end	
  	end	
  end

  def edit
    set_initialization
    @channel = Channel.find(params[:id], :include => :courses)
    if @channel.courses.count.zero?
      @channel.courses.build()
    end
  end

  def update
    set_initialization
    @channel = Channel.cached_find(params[:id])
    respond_to do |format|  
      if @channel.update_attributes(params[:channel])
        format.html {redirect_to admin_channels_url}
        flash[:notice] = "Channel has successfully update"
      else
        format.html { render :action => "edit" }
      end 
    end 
  end

  def destroy
    channel = Channel.find(params[:id], :include => :courses)
    channel.destroy
    respond_to do |format|
      format.html { redirect_to admin_channels_url}   
    end  
  end

  def get_channel
    if params[:id]
      @channel = Channel.cached_find(params[:id])
      respond_to do |format|
        format.json{}
      end
    end
  end

  def channel_courses
    channel = Channel.find(params[:id], :include => :courses)
    @channel_courses = channel.courses

  end

  private
  def set_initialization
    @subscriptions = Subscription.all
  end
end
