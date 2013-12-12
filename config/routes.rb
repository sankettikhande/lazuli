Lazuli::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  get "/admin", :controller => "admin", :action => :index
  
  namespace :admin do
    resources :users do
    	collection do
    		get 'search_user'
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
    resources :courses
    resources :topics
  end

  root :to => "home#index"
end
