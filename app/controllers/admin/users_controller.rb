class Admin::UsersController < AdminController
  def index
    @users = User.all
  end

  def new
  	@user = User.new
  end	

  def create
  	@user = User.new(params[:user])
  	respond_to do |format|
  		if @user.save
  			format.html {redirect_to admin_users_url}
  		else
  			format.html { render :action => "new" }
  		end	
  	end	
  end	
end
