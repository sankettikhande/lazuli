class UsersController < ApplicationController
	load_and_authorize_resource
    rescue_from CanCan::AccessDenied do |exception|
     redirect_to root_url, :alert => exception.message
    end

	def update
    @user = User.cached_find(params[:id])   
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.js
        flash[:success] = "User has been successfully updated."
      else       
        format.js
      end
    end
  end   
end
