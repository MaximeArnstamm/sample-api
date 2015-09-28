Rails.application.routes.draw do
  apipie

  devise_for :users, :path_prefix => 'api/v1', :skip => [:sessions, :registrations, :passwords]

  namespace :api do
    namespace :v1 do
      # authent
      devise_scope :user do
        post 'login' => 'sessions#create', :as => :login
        delete 'logout' => 'sessions#destroy', :as => :logout
        post 'register' => 'registrations#create', :as => :register
        delete 'delete_account' => 'registrations#destroy', :as => :delete_account
      end
      # users/
      resources :users, only: [:show, :update] do
        # users/:id/events/
        resources :events
      end
    end
  end
  
end
