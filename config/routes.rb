Lazuli::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :sessions => 'sessions', :registrations => 'registrations'}

  get "/admin", :controller => "admin", :action => :index
  
  namespace :admin do
    resources :users do
    	collection do
    		get 'search_user'
        get 'new_bulk'
        post 'create_bulk'
        get 'search'
    	end
    	member do
    		get 'get_user'
    	end
    end
    resources :channels do
      member do
        get 'get_channel'
        get 'channel_courses'
      end
      collection do
        get 'search'
      end
    end

    resources	:contents do
      collection do
        get 'get_topics'
        get 'get_videos'
        get 'get_courses'
      end
    end
    resources :courses do
      member do
        get 'get_channel_info'
        get 'course_subscription_types'
      end
      collection do
        get 'search'
      end
    end
    resources :topics do
      collection do
        get 'search'
      end
    end
    resources :videos do
      member do
        get 'upload'
      end
      collection do
        get 'search'
      end
    end
    resources :bookmarks do 
      member do
        post 'create_bulk'
        get 'bookmark_video'
      end
    end
    resources :user_channel_subscriptions
  end
  get "/delayed_job" => DelayedJobWeb, :anchor => false
  root :to => "home#index"
end
