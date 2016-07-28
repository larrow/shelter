require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  resources :dashboard, controller: 'dashboard', only: [:index]

  devise_for :users
  root to: 'home#index'

  post 'service/notifications'
  get 'service/token'
  get 'search', to: 'search#index'

  resources :namespaces, path: '/n', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:new, :create, :edit] do
    resources :group_members, path: '/members', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :create, :new, :destroy] do
      member do
        post 'toggle_access_level'
      end
    end
  end

  resources :namespaces, path: '/', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:show, :destroy] do
    resources :repositories, path: '/', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:show, :update, :destroy] do
      resources :repository_members, path: '/members', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :create, :new, :destroy] do
        member do
          post 'toggle_access_level'
        end
      end

      member do
        post 'toggle_publicity'
      end

      resources :tags, constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :destroy]
    end
  end

end
