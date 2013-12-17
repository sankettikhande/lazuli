Lazuli::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  get "/admin", :controller => "admin", :action => :index
  
  namespace :admin do
    resources :users do
    	collection do
    		get 'search_user'
               get 'new_bulk'
               post 'create_bulk'
               get 'course_subscription_types'
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
    resources :videos do
      member do
        get 'upload'
      end
    end
  end
  get "/delayed_job" => DelayedJobWeb, :anchor => false
  root :to => "home#index"
end
