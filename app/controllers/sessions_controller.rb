class SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate(:scope => resource_name, :recall => 'sessions#failure')
    if resource
      sign_in_and_redirect(resource_name, resource)
    else
      render :action => :failure
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
end