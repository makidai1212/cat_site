Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
  get '/signup', to: 'users#new'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  root 'static_pages#home'
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy, :show] do
   resources :comments, only: [:create]
  end
  resources :comments, only: [:destroy]
  resources :users do
    member do
      get :following, :followers, :likes
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :notifications, only: :index
end
