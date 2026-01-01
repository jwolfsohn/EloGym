Rails.application.routes.draw do
  # Root route
  root "dashboard#index"

  # API endpoints
  namespace :api do
    namespace :users do
      post "signup"
      post "login"
      get "profile"
      patch "split"
      post "starting-stats"
      get "daily-exercises"
      post "complete-exercise"
    end

    namespace :matchmaking do
      get "friends"
      post "friends/add"
      get "search"
      namespace :battle do
        post "challenge"
      end
    end
  end

  # Frontend routes
  get "dashboard", to: "dashboard#index"
  get "onboarding", to: "onboarding#index"
  get "onboarding/welcome", to: "onboarding#welcome"
  get "onboarding/split", to: "onboarding#split"
  post "onboarding/split", to: "onboarding#save_split"
  get "onboarding/stats", to: "onboarding#stats"
  post "onboarding/stats", to: "onboarding#save_stats"

  resources :battles, only: [:index]
  resources :users, only: [:show]

  # Auth pages
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
