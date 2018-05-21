Rails.application.routes.draw do
  #check back in on this (and views) later
  get 'settings', to: 'settings#show'

# reconfigure and clean up routes

  resources :electric_bills, only: [:create]
  resources :water_bills, only: [:create]
  resources :gas_bills, only: [:create]
  resources :users, only: [:create, :update]
  resources :addresses, only: [:create]
  resources :houses, only: [:create]

  namespace :api do
    namespace :v1 do
      resources :addresses, only: [:index, :show]
      resources :houses, only: [:index, :show]
      get 'houses/:id/users', to: 'houses#users'
      resources :users, only: [:index, :show] do
          resources :houses
          put '/electricity', to: 'users/users_electricity#update'
          put '/water', to: 'users/users_water#update'
          put '/gas', to: 'users/users_gas#update'
          # get '/trips', to: 'users/trips#index'
            # get '/groups', to: 'users/groups#index'
            # get '/groups/:id', to: 'users/groups#show'
                # get '/friends', to: 'users/friends#index'
            # get '/friends/:id', to: 'users/friends#show'
            # get '/admins', to: 'users/admins#index'
          # get '/days', to: 'users/days#index'
      end
      get '/users/:id/resources', to: 'users#resources'
      namespace :areas do
        get '/countries', to: 'country#index'
        get '/countries/electricity', to: 'country_electricity#index'
        get '/countries/:id/electricity', to: 'country_electricity#show'
        get '/countries/:id/electricity/users', to: 'country_electricity#users'
        put '/countries/:id/electricity', to: 'country_electricity#update'

        get '/countries/water', to: 'country_water#index'
        get '/countries/:id/water', to: 'country_water#show'
        get '/countries/:id/water/users', to: 'country_water#users'
        put '/countries/:id/water', to: 'country_water#update'

        get '/countries/gas', to: 'country_gas#index'
        get '/countries/:id/gas', to: 'country_gas#show'
        get '/countries/:id/gas/users', to: 'country_gas#users'
        put '/countries/:id/gas', to: 'country_gas#update'

        get '/countries/carbon', to: 'country_carbon#index'
        get '/countries/:id/carbon', to: 'country_carbon#show'

        get '/regions', to: 'region#index'
        get '/regions/electricity', to: 'region_electricity#index'
        get '/regions/:id/electricity', to: 'region_electricity#show'
        get '/regions/:id/electricity/:users', to: 'region_electricity#users'
        put '/regions/:id/electricity', to: 'region_electricity#update'

        get '/regions/water', to: 'region_water#index'
        get '/regions/:id/water', to: 'region_water#show'
        get '/regions/:id/water/users', to: 'region_water#users'
        put '/regions/:id/water', to: 'region_water#update'

        get '/regions/gas', to: 'region_gas#index'
        get '/regions/:id/gas', to: 'region_gas#show'
        get '/regions/:id/gas/users', to: 'region_gas#users'
        put '/regions/:id/gas', to: 'region_gas#update'

        get '/regions/carbon', to: 'region_carbon#index'
        get '/regions/:id/carbon', to: 'region_carbon#show'

        get '/cities', to: 'city#index'
        get '/cities/show/:id', to: 'city#show'
        get '/cities/electricity', to: 'city_electricity#index'
        get '/cities/:id/electricity', to: 'city_electricity#show'
        get '/cities/:id/electricity/users', to: 'city_electricity#users'
        put '/cities/:id/electricity', to: 'city_electricity#update'

        get '/cities/water', to: 'city_water#index'
        get '/cities/:id/water', to: 'city_water#show'
        get '/cities/:id/water/users', to: 'city_water#users'
        put '/cities/:id/water', to: 'city_water#update'

        get '/cities/gas', to: 'city_gas#index'
        get '/cities/:id/gas', to: 'city_gas#show'
        get '/cities/:id/gas/users', to: 'city_gas#users'
        put '/cities/:id/gas', to: 'city_gas#update'

        get '/cities/carbon', to: 'city_carbon#index'
        get '/cities/:id/carbon', to: 'city_carbon#show'

        get '/neighborhoods', to: 'neighborhood#index'
        get '/neighborhoods/electricity', to: 'neighborhood_electricity#index'
        get '/neighborhoods/:id/electricity', to: 'neighborhood_electricity#show'
        get '/neighborhoods/:id/electricity/users', to: 'neighborhood_electricity#users'
        put '/neighborhoods/:id/electricity', to: 'neighborhood_electricity#update'

        get '/neighborhoods/water', to: 'neighborhood_water#index'
        get '/neighborhoods/:id/water', to: 'neighborhood_water#show'
        get '/neighborhoods/:id/water/users', to: 'neighborhood_water#users'
        put '/neighborhoods/:id/water', to: 'neighborhood_water#update'

        get '/neighborhoods/gas', to: 'neighborhood_gas#index'
        get '/neighborhoods/:id/gas', to: 'neighborhood_gas#show'
        get '/neighborhoods/:id/gas/users', to: 'neighborhood_gas#users'
        put '/neighborhoods/:id/gas', to: 'neighborhood_gas#update'

        get '/neighborhoods/carbon', to: 'neighborhood_carbon#index'
        get '/neighborhoods/:id/carbon', to: 'neighborhood_carbon#show'
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
  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create", :defaults => {:format => :json}
end
