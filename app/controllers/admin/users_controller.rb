class Admin::UsersController < AdminController
  before_filter :set_instance, :only => [:new, :create, :edit, :update, :new_bulk, :create_bulk]
  
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
    @user.skip_confirmation!
    respond_to do |format|
      if @user.save
        flash[:notice] = "User has been created."
        format.js
      else
        format.js
      end
    end
  end	

  def edit
    @user = User.cached_find(params[:id])
    @user_channel = @user.user_channel_subscriptions
  end 

  def update
    @user = User.cached_find(params[:id])
    params[:user].delete('password') if params[:user][:password].blank?
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.js
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
    @users = User.where("name like ?", "%#{params[:name]}%").limit(20)
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
          @users.each(&:skip_confirmation!)
          @users.each(&:save!)
          flash[:notice] = "Users have been created."
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
    @channels = Channel.all
    @subscriptions = []
    @courses = []
  end

end
