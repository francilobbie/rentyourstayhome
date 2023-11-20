Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root "home#index"

  namespace :api do
    get "/user_by_email" => "user_by_email#show", as: :user_by_email
    resources :favorites, only: [:index, :destroy]
    post "/favorites" => "favorites#create", as: :create_favorite
  end

  resources :user_management, only: [:index, :show, :create, :update, :destroy]
  get 'mapbox/search', to: 'mapbox#search'


  get "/flats/search" => "flats/search#index", as: :search_flats

  resources :flats, only: [:index, :show, :create, :edit, :update, :destroy] do
    resources :bookings, only: :new, controller: "flats/bookings"
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:destroy]



  resources :reservations_payements, only: :create

  resources :profiles, only: [:show, :update] do
    member do
      delete "delete_avatar"
    end
  end
  resources :reviews, only: [:index, :new, :create, :destroy]
  resources :accounts, only: [:show, :update]
  resources :passwords, only: [:show, :update]
  resources :payements, only: :index
  resources :favorites, only: :index

  put "/hostify/:user_id" => "hostify#update", as: :hostify

  namespace :host do
    get "dashboard" => "dashboard#index", as: :dashboard
    resources :flats, only: [:index, :new, :create, :edit, :update, :destroy] do
      member do
        delete :delete_image
      end
    end
    resources :payements, only: :index
  end

end
