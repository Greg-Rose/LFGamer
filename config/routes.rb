Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: :registrations }
  resources :games, only: [:index, :show]

  root 'games#index'
end
