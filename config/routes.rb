Rails.application.routes.draw do

  resources :electric_bills, only: [:new, :create]
  resources :users, only: [:new, :create, :show, :update]
  resources :addresses, only: [:new, :create, :show]
  resources :houses, only: [:new, :create]

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        get '/trips', to: 'users/trips#index'
        get '/groups', to: 'users/groups#index'
        get '/groups/:id', to: 'users/groups#show'
        get '/friends', to: 'users/friends#index'
        get '/friends/:id', to: 'users/friends#show'
        get '/admins', to: 'users/admins#index'
        get '/days', to: 'users/days#index'
      end
      resources :admins, only: [:index, :show]
      resources :trips
      resources :groups, only: [:index, :show] do
        get '/members', to: 'groups/group_members#index'
      end
      resources :days, only: [:index, :show]
    end
  end
  get '/', to: "sessions#index", as: :welcome
  get '/auth/facebook', as: :facebook_login
  get '/auth/facebook/callback', to: "sessions#create", as: :facebook_callback
  get '/logout', to: "sessions#destroy", as: :logout
  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create"
end
