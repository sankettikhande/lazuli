Lazuli::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  namespace :admin do
    resources :users
    resources :channels
  end

  match '/course_subscription_types', :controller => "admin/users", :action => "course_subscription_types"

  root :to => "home#index"
end
