class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    @user = User.find_for_oauth(request.env["omniauth.auth"], request.env["omniauth.auth"].extra.raw_info, current_user)
    login_or_redirect("Facebook")
    
  end

  def google_oauth2
    @user = User.find_for_oauth(request.env["omniauth.auth"], request.env["omniauth.auth"].info, current_user)
    login_or_redirect("Google")
  end  

  def linkedin
    @user = User.find_for_oauth(request.env["omniauth.auth"], request.env["omniauth.auth"].info, current_user)
    login_or_redirect("Linkedin")
  end 

  private
    def login_or_redirect(provider)
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

end