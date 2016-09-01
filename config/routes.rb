require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do

  namespace :admin do
    get 'settings', to: 'settings#index'
    post 'settings', to: 'settings#update'
    resources :users
    resources :namespaces
    resources :repositories
  end

  mount Sidekiq::Web => '/sidekiq'

  resources :dashboard, controller: 'dashboard', only: [:index]

  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'

  post 'service/notifications'
  get 'service/token'
  get 'search', to: 'search#index'

  resources :namespaces, path: '/n', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:new, :create] do
    resources :group_members, path: '/members', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :create, :new, :destroy] do
      member do
        post 'toggle_access_level'
      end
    end

  end

  resources :namespaces, path: '/', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:show, :destroy] do
    member do
      get 'settings'
    end

    resources :repositories, path: '/', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:show, :update] do
      resources :repository_members, as: :members, path: '/members', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :create, :new, :destroy] do
        member do
          post 'toggle_access_level'
        end
      end

      member do
        post 'toggle_publicity'
        get 'edit_description'
      end

      resources :tags, constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :destroy]
    end
  end


end
