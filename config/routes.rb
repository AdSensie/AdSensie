Rails.application.routes.draw do
  devise_for :users
  
  # Root path
  root "dashboard#index"
  
  # Dashboard
  get "dashboard", to: "dashboard#index", as: :dashboard
  post "dashboard/sync", to: "dashboard#sync", as: :sync_dashboard
  
  # Performance comparison
  get "performance", to: "performance#index"
  
  # Channels
  resources :channels, only: [:index, :show] do
    collection do
      get :compare
    end
  end
  
  # Collections
  resources :collections do
    member do
      post "add_channel/:channel_id", to: "collections#add_channel", as: :add_channel
      delete "remove_channel/:channel_id", to: "collections#remove_channel", as: :remove_channel
    end
  end
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
