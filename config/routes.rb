Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "static_pages#home"
  get "/about", to: "static_pages#about"
  get "/signup", to: "users#new"
  resources :users do
    member do
      get :bookmarking
    end
  end
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :shops do
    resources :reviews, only: [:create, :destroy]
  end
  resources :bookmarks, only: [:create, :destroy]
  post "/guest_login", to: "sessions#guest_login"
  resources :tags do
    get :shops, to: "shops#tag_search"
  end
  resources :likes, only: [:create, :destroy]
end
