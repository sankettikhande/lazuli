class Admin::UsersController < AdminController
  before_filter :set_instance, :only => [:new, :create, :edit, :update, :new_bulk, :create_bulk]
  load_and_authorize_resource

  def index     
  end

  def search
    @users = User.sphinx_search(params, current_user)   
  end  

  def new
    @user = User.new
    @user.user_channel_subscriptions.build
  end	

  def create
    @user = User.new(params[:user])
    @user.created_by = current_user.id
    respond_to do |format|
      if @user.save
        @user.set_course_admin_user_id
        flash[:success] = "User has been created. Awaiting for confirmation..."
        format.js
      else
        format.js
      end
    end
  end	

  def edit
    @user = User.cached_find(params[:id])
    @edit_permission = (current_user.is_admin? ||@user == current_user || @user.created_by == current_user.id) ? false : true
    @user_channel = @user.user_channel_subscriptions
  end 

  def update
    @user = User.cached_find(params[:id])
    params[:user].delete('password') if params[:user][:password].blank?
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.js
        flash[:success] = "User has been successfully updated."
      else
        @user_channel = @user.user_channel_subscriptions
        format.js
      end
    end
  end   

  def destroy
    user = User.cached_find(params[:id])
    user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url}   
    end  
  end

  def search_user
    @users = User.search(actual_name = "#{params[:q]}*", :without => {:confirm_status => 0})
    respond_to do |format|
      format.json {}
    end  
  end

  def get_user
    @user = User.cached_find(params[:id])
    respond_to do |format|
      format.json {}   
    end  
  end

  def new_bulk
    @user =User.new
    @user_error = ''
    @user.user_channel_subscriptions.build
  end 

  def create_bulk
    @bulk_user_errors = User.bulksheet_errors(params[:user][:file])
    if @bulk_user_errors.blank?
      created_by = current_user.id 
      @users = User.import_users(params[:user], created_by)
      respond_to do |format|
        if @users.map(&:valid?).all?
          @users.each(&:save!)
          flash[:success] = "Users have been created. Awaiting for confirmations..."
          format.js
        else
          build_user_and_association(:errors => @users.map(&:errors).map(&:full_messages).flatten)
          format.js
        end
      end    
    else
      build_user_and_association(:errors => @bulk_user_errors)
      render :format => [:js]
    end  
  end

private

  def build_user_and_association(options={})
    user_params = params[:user]
    user_params.delete("file")
    @user = User.new(user_params)
    @bulk_user_errors = options[:errors] || [] 
  end
  
  def set_instance
    @channels = current_user.is_admin? ? Channel.cached_all : current_user.administrated_channels  
    @subscriptions = []
    @courses = []
  end

end
