Lazuli::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  namespace :admin do
    resources :users
    resources :channels
  end

  root :to => "home#index"
end
