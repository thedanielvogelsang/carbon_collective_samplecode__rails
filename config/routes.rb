Rails.application.routes.draw do
  get 'settings', to: 'settings#show'

# reconfigure and clean up routes

  resources :electric_bills, only: [:create]
  resources :users, only: [:new, :create, :show, :update]
  resources :addresses, only: [:new, :create, :show]
  resources :houses, only: [:new, :create]

  namespace :api do
    namespace :v1 do
      resources :addresses, only: [:index, :show]
      resources :houses, only: [:index, :show]
      resources :users, only: [:index, :show] do
        resources :houses
        # get '/trips', to: 'users/trips#index'
        # get '/groups', to: 'users/groups#index'
        # get '/groups/:id', to: 'users/groups#show'
        # get '/friends', to: 'users/friends#index'
        # get '/friends/:id', to: 'users/friends#show'
        # get '/admins', to: 'users/admins#index'
        # get '/days', to: 'users/days#index'
      end
      namespace :areas do
        get '/countries/electricity', to: 'country_electricity#index'
        get '/countries/:id/electricity', to: 'country_electricity#show'
        get '/countries/:id/electricity/users', to: 'country_electricity#users'
        get '/regions/electricity', to: 'region_electricity#index'
        get '/regions/:id/electricity', to: 'region_electricity#show'
        get '/regions/:id/electricity/users', to: 'region_electricity#users'
        get '/cities/electricity', to: 'city_electricity#index'
        get '/cities/:id/electricity', to: 'city_electricity#show'
        get '/cities/:id/electricity/users', to: 'city_electricity#users'
        get '/neighborhoods/electricity', to: 'neighborhood_electricity#index'
        get '/neighborhoods/:id/electricity', to: 'neighborhood_electricity#show'
        get '/neighborhoods/:id/electricity/users', to: 'neighborhood_electricity#users'
      end
      # resources :admins, only: [:index, :show]
      # resources :trips
      # resources :groups, only: [:index, :show] do
      #   get '/members', to: 'groups/group_members#index'
      # end
      # resources :days, only: [:index, :show]
    end
  end
  get '/', to: "sessions#index", as: :welcome
  get '/auth/facebook', as: :facebook_login
  get '/auth/facebook/callback', to: "sessions#create", as: :facebook_callback
  get '/logout', to: "sessions#destroy", as: :logout
  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create", :defaults => {:format => :json}
end
