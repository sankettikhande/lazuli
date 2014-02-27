class SessionsController < Devise::SessionsController

  before_filter :load_course, :only => [:new]

  def create
    user=User.find_by_email(params[:user][:email])
    if user.confirmed?    
      resource = warden.authenticate(:scope => resource_name, :recall => 'sessions#failure')
      if resource
        sign_in_and_redirect(resource_name, resource)
      else
        render :action => :failure
      end
    else            
      respond_to do |format|
        format.js 
      end
      flash[:error] = "You have to confirm your account before continuing."    
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    respond_to do |format|
      format.js
    end
  end

  def failure   
    respond_to do |format|
      format.js
    end
  end

  private
  def load_course
    @topics = Topic.published.not_bookmarked.limit(3)
    @courses = Course.public_channel_courses(3)
  end
end