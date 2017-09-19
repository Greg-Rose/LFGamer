Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: :registrations }
  devise_scope :user do
    get 'users/delete', action: 'delete', controller: 'registrations', as: 'delete_user_registration'
  end

  resources :games, only: [:index, :show]
  resources :profiles, only: [:show]
  resource :profile, only: [:edit, :update]
  resource :ownerships, only: [:create]
  resources :lfgs, only: [:create, :update, :destroy]

  namespace :api do
    namespace :v1 do
      resources :lfgs, only: [:create, :update, :destroy]
    end
  end

  resources :conversations, only: [:index, :create, :show, :destroy] do
    resources :messages, only: [:create]
  end

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :users, only: [:index, :show]
    resources :consoles, only: [:index]
    resources :ownerships, only: [:index]
    resources :games, only: [:index, :new, :create]
    resources :lfgs, only: [:index]
    resources :conversations, only: [:index]
    get 'games/search', to: 'games#search', as: 'games_search'
  end

  root 'games#index'
end
