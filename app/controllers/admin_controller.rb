class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_user_roles, :verify_admin, :get_inbox_count
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  layout 'admin'

  def index
    if @user_roles.include? "admin" or @user_roles.include? "channel_admin"
      redirect_to admin_users_path
    elsif @user_roles.include? "course_admin"
      redirect_to admin_contents_path
    end
  end

  private
  def get_user_roles
    @user_roles = current_user.roles.map(&:name)
  end  

  def verify_admin
    redirect_to root_url if !(@user_roles.include? "admin" or @user_roles.include? "channel_admin" or @user_roles.include? "course_admin")
  end

  def get_inbox_count
    @total_count = ContactUs.admin_inbox_count(current_user)
  end 
end
