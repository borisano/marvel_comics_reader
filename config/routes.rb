Rails.application.routes.draw do
  get 'about', to: 'pages#about'

  resources :home, only: [:index] do
    collection do
      get 'fav_status', to: 'home#fav_status', as: 'fav_status'
      post ':id/fav', to: 'home#fav', as: 'fav'
      delete ':id/fav', to: 'home#unfav', as: 'unfav'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
