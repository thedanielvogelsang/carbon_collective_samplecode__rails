Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        get '/trips', to: 'users/trips#index'
        get '/groups', to: 'users/groups#index'
        get '/groups/:id', to: 'users/groups#show'
        get '/friends', to: 'users/friends#index'
        get '/friends/:id', to: 'users/friends#show'
        get '/admins', to: 'users/admins#index'
      end
      resources :admins, only: [:index, :show]
      resources :trips
      resources :groups, only: [:index, :show] do
        get '/members', to: 'groups/group_members#index'
      end
      resources :days, only: [:index, :show]
    end
  end
end
