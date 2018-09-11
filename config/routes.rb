Rails.application.routes.draw do
  #check back in on this (and views) later
  get 'settings', to: 'settings#show'

# reconfigure and clean up routes

  get '/', to: "sessions#index", as: :welcome
  get '/auth/facebook', as: :facebook_login
  get '/auth/facebook/callback', to: "sessions#create", as: :facebook_callback
  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create", :defaults => {:format => :json}
  post '/suggestions', to: 'suggestions#send_suggestion'
  post '/expansions', to: 'suggestions#region_expansion'
  post '/store_geo', to: 'suggestions#region_data'
  post '/bugs', to: "suggestions#send_bug"
  resources :users, only: [:create, :update]
  post '/users/:user_id/old_houses/:house_id', to: 'users#old_houses'
  post '/users/invite/:id', to: 'users#invite'
  post '/:user_id/presses-btn', to: 'user_behaviors#presses_button'
  post '/:user_id/page-land', to: 'user_behaviors#page_land'
  post '/:user_id/page-leave', to: 'user_behaviors#page_leave'
  post '/:user_id/page-mounted', to: 'user_behaviors#page_mounted'
  post '/:user_id/presses-nav-btn', to: 'user_behaviors#presses_navbar_button'
  post '/:user_id/user-logs-in', to: 'user_behaviors#logs_in'
  post '/:user_id/user-logs-out', to: 'user_behaviors#logs_out'
  get '/:user_id/invites', to: 'users#user_invites'
  post '/:user_id/cancel-invite/:invite_id', to: 'users#cancel_invite'
  resource :users do
    member do
      get :confirm_email
      get :invite_accepted, as: "invite"
    end
  end
  resources :addresses, only: [:create]
  resources :houses, only: [:create]
  namespace :api do
    namespace :v1 do
      resources :addresses, only: [:index, :show]
      resources :houses, only: [:index, :show, :update]
      get 'houses/:id/users', to: 'houses#users'
      resources :users, only: [:index, :show] do
          resources :houses
          get '/houses/:house_id/questions', to: 'users/questions#show'
          put '/houses/:house_id/questions', to: 'users/questions#update'
          put '/electricity', to: 'users/users_electricity#update'
          put '/water', to: 'users/users_water#update'
          put '/gas', to: 'users/users_gas#update'
          put '/carbon', to: 'users/users_carbon#update'
          get '/bills/electricity', to: 'users/users_electric_bills#index'
          get '/bills/water', to: 'users/users_water_bills#index'
          get '/bills/gas', to: 'users/users_gas_bills#index'
          put '/bills/electricity/:id', to: 'users/users_electric_bills#update'
          put '/bills/water/:id', to: 'users/users_water_bills#update'
          put '/bills/gas/:id', to: 'users/users_gas_bills#update'
          post '/electric_bills', to: 'users/users_electric_bills#create'
          post '/water_bills', to: 'users/users_water_bills#create'
          post '/gas_bills', to: 'users/users_gas_bills#create'
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
        get '/countries/:id/carbon/users', to: 'country_carbon#users'
        get '/countries/:id/carbon', to: 'country_carbon#show'
        put '/countries/:id/carbon', to: 'country_carbon#update'

        get '/regions', to: 'region#index'
        get '/regions/show/:id', to: 'region#show'
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
        get '/regions/:id/carbon/users', to: 'region_carbon#users'
        get '/regions/:id/carbon', to: 'region_carbon#show'
        put '/regions/:id/carbon', to: 'region_carbon#update'

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
        get '/cities/:id/carbon/users', to: 'city_carbon#users'
        get '/cities/:id/carbon', to: 'city_carbon#show'
        put '/cities/:id/carbon', to: 'city_carbon#update'

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
        get '/neighborhoods/:id/carbon/users', to: 'neighborhood_carbon#users'
        get '/neighborhoods/:id/carbon', to: 'neighborhood_carbon#show'
        put '/neighborhoods/:id/carbon', to: 'neighborhood_carbon#update'

        get '/counties', to: 'county#index'
        get '/counties/electricity', to: 'county_electricity#index'
        get '/counties/:id/electricity', to: 'county_electricity#show'
        get '/counties/:id/electricity/users', to: 'county_electricity#users'
        put '/counties/:id/electricity', to: 'county_electricity#update'

        get '/counties/water', to: 'county_water#index'
        get '/counties/:id/water', to: 'county_water#show'
        get '/counties/:id/water/users', to: 'county_water#users'
        put '/counties/:id/water', to: 'county_water#update'

        get '/counties/gas', to: 'county_gas#index'
        get '/counties/:id/gas', to: 'county_gas#show'
        get '/counties/:id/gas/users', to: 'county_gas#users'
        put '/counties/:id/gas', to: 'county_gas#update'

        get '/counties/carbon', to: 'county_carbon#index'
        get '/counties/:id/carbon/users', to: 'county_carbon#users'
        get '/counties/:id/carbon', to: 'county_carbon#show'
        put '/counties/:id/carbon', to: 'county_carbon#update'
      end
      # resources :admins, only: [:index, :show]
      # resources :trips
      # resources :groups, only: [:index, :show] do
      #   get '/members', to: 'groups/group_members#index'
      # end
      # resources :days, only: [:index, :show]
    end
  end
end
