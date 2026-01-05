Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "registrations#new"
  
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "dashboard", to: "dashboard#index"
  
  get "onboarding/welcome", to: "onboarding#welcome"
  get "onboarding/split", to: "onboarding#split"
  post "onboarding/save_split", to: "onboarding#save_split"
  get "onboarding/stats", to: "onboarding#stats"
  post "onboarding/save_stats", to: "onboarding#save_stats"

  resources :battles, only: [:index]
  get "rank", to: "users#rank"
end
