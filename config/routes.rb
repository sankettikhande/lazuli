Lazuli::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  get "/admin", :controller => "admin", :action => :index
  
  namespace :admin do
    resources :users do
    	collection do
    		get 'search_user'
    	end
    	member do
    		get 'get_user'
    	end
    end
    resources :channels do
      member do
        get 'get_channel'
      end
    end

    resources	:contents
    resources :courses do
      member do
        get 'get_channel_info'
      end
    end
    resources :topics
  end

  match '/course_subscription_types', :controller => "admin/users", :action => "course_subscription_types"

  root :to => "home#index"
end
