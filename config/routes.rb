Lazuli::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :sessions => 'sessions', :registrations => 'registrations'}

  get "/admin", :controller => "admin", :action => :index
  get "/delayed_job" => DelayedJobWeb, :anchor => false
  root :to => "home#index"
  
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
        get 'course_videos'
      end
      collection do
        get 'search'
      end
    end
    resources :topics do
      member do
        get 'topic_videos'
      end
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
  resources :channels, :only => [:index, :show] 
  resources :courses, :only => [:index, :show]
  resources :watch_lists, :only => [:index, :destroy] do
    collection do
      post 'remove'
    end
  end
  resources :videos do
    collection do
      get 'tag_videos'
      get 'tag_search'
    end
  end
  resources :histories, :only => [:index, :destroy] do
    collection do
      post 'remove'
    end
    member do
      get 'save_history'
    end
  end
  resources :favourites, :only => [:index, :create, :destroy] do
    collection do
      post 'remove'
      delete 'delete_favs'
    end
  end
  resources :subscriptions, :only => [:destroy]

  match '/browse_course' => 'home#browse_course'
  match '/courses/:id/:video_id' => 'courses#show', :as => :course_videos
  match '/courses/:id' => 'courses#show', :as => :course_video
  match '/subscribe/course/:id' => 'subscriptions#subscribe_course', :as => :subscribe_course
  match '/add/watchlist/video/:id/:course_id' => 'watch_lists#add_to_watch_list', :as => :add_to_watch_list
  match '/remove/watchlist/video/:id/:course_id' => 'watch_lists#remove_from_watch_list', :as => :remove_from_watch_list
  match '/favourites/search' => 'favourites#search', :as => :search_favourites
  match '/histories/search' => 'histories#search', :as => :search_histories
  match '/watch_lists/search' => 'watch_lists#search', :as => :search_watch_lists
end
