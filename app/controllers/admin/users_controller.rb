class Admin::UsersController < AdminController
  
  def index
    @users = User.order((params[:sort_column] || "name") + " " + (params[:direction] || "asc"))
  end

  def new
    @user = User.new
    set_instance
    @user.user_channel_subscriptions.build
  end	

  def create
  	@user = User.new(params[:user])
  	respond_to do |format|
      if @user.save
        format.html {redirect_to admin_users_url}
      else
        set_instance
        format.html { render :action => "new" }
      end
    end
  end	

  def edit
    @user = User.find_by_id(params[:id])
    @user_channel = @user.user_channel_subscriptions
  end 

  def update
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to admin_users_url}
      else
        @user_channel = @user.user_channel_subscriptions
        format.html{ render :action => "edit"}       
      end
    end
  end   

  def destroy
    user = User.find_by_id(params[:id])
    user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url}   
    end  
  end

  def search_user
    @users = User.where("name like ?", "%#{params[:name]}%").limit(20)
    respond_to do |format|
      format.json {}   
    end  
  end

  def get_user
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      format.json {}   
    end  
  end 

  def course_subscription_types
    if params[:id]
      channel = Channel.find_by_id(params[:id])
      @channel_courses = channel.try(:courses)
      respond_to do |format|
        format.js
      end
    end  
  end

  def new_bulk
    @user =User.new
    set_instance
    @user_error = ''
    @user.user_channel_subscriptions.build
  end 

  def create_bulk
    @bulk_user_errors = User.bulksheet_errors(params[:user][:file])
    if @bulk_user_errors.blank? 
      @users = User.import_users(params[:user])
      respond_to do |format|
        if @users.map(&:valid?).all?
          @users.each(&:save!)
          format.html {redirect_to admin_users_url}
        else
          build_user_and_association(:errors => @users.map(&:errors).map(&:full_messages).flatten)
          format.html { render :action => "new_bulk" }
        end
      end    
    else
      build_user_and_association(:errors => @bulk_user_errors)
      render :action => "new_bulk"
    end  
  end

private

  def build_user_and_association(options={})
    user_params = params[:user]
    user_params.delete("file")
    @user = User.new(user_params)
    @bulk_user_errors = options[:errors] || [] 
    set_instance
  end
  
  def set_instance
    @channels = Channel.all
    @subscriptions = Subscription.all
    @courses = Course.all
  end

end
