Rails.application.routes.draw do
  resources :games, only: [:index, :show]
end
