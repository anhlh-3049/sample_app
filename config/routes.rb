Rails.application.routes.draw do
  get "/home" ,to:"static_pages#home"
  get "/help" ,to:"static_pages#help"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  root "static_pages#home"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users do
    member do
      resources :followers, only: %i(index)
      resources :followings, only: %i(index)
    end
  end
  resources :account_activations, only: :edit
  resources :password_resets, only: %i(new create edit update)
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: %i(create destroy)

end
