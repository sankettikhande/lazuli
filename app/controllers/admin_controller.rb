class AdminController < ApplicationController
  before_filter :verify_admin
  layout 'admin'

  def index
  end

  private

  def verify_admin
    redirect_to root_url unless (current_user.try(:is_admin?) rescue false)
  end
end
