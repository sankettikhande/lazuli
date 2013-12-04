Lazuli::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  namespace :admin do
    resources :users do
    	collection do
    		get 'search_user'
    	end
    	member do
    		get 'get_user'
    	end
    end
    resources :channels
    resources	:contents
    resources :courses
    resources :topics
  end

  match '/course_subscription_types', :controller => "admin/users", :action => "course_subscription_types"

  root :to => "home#index"
end
