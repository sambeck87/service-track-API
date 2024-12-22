Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      post 'login', to: 'auth#login'

      resources :users, only: [:create]

      resources :cars, only: [:index, :show, :create, :update, :destroy]

      resources :maintenance_services, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
