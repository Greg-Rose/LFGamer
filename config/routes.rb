Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: :registrations }
  devise_scope :user do
    get 'users/delete', action: 'delete', controller: 'registrations', as: 'delete_user_registration'
  end
  resources :games, only: [:index, :show]
  resources :profiles, only: [:show]
  resource :profile, only: [:edit, :update]

  root 'games#index'
end
