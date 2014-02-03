class Admin::ChannelsController < AdminController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  before_filter :set_initialization, :only => [:new, :create, :edit, :update]

  def index
  end

  def new
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
    @channel = Channel.new(params[:channel])
    @channel.courses.each do |course|
      course.created_by = current_user.id
      course.channel_admin_user_id = @channel.admin_user_id
    end
    respond_to do |format|
  		if @channel.save
  			format.html {redirect_to admin_channels_url}
        flash[:success] = "Channel has been successfully created"
  		else
  			format.html { render :action => "new" }
  		end	
  	end	
  end

  def edit
    @channel = Channel.find(params[:id], :include => :courses)
    if @channel.courses.count.zero?
      @channel.courses.build()
    end
  end

  def update
    @channel = Channel.cached_find(params[:id])
    respond_to do |format|  
      if @channel.update_attributes(params[:channel])
        format.html {redirect_to admin_channels_url}
        flash[:success] = "Channel has been successfully update"
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
    @channel_courses = channel.permitted_courses(current_user)

  end

  private
  def set_initialization
    @subscriptions = Subscription.cached_all
  end
end
