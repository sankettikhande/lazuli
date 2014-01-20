class AdminController < ApplicationController
  before_filter :verify_admin
  layout 'admin'

  def index
    redirect_to admin_users_path
  end

  private

  def verify_admin
    user_roles = current_user.roles.map(&:name)
    redirect_to root_url if !(user_roles.include? "admin" or user_roles.include? "channel_admin" or user_roles.include? "course_admin")
  end
end
