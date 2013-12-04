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

  def edit
    @user = User.find_by_id(params[:id])
  end 

  def update
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to admin_users_url}
      else
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

end
