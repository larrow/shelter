Rails.application.routes.draw do

  resources :dashboard, controller: 'dashboard', only: [:index]

  devise_for :users
  root to: 'home#index'

  post 'service/notifications'
  get 'service/token'

  resources :namespaces, path: '/n', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:new, :create, :edit] do
    member do
      get 'teams'
      get 'settings'
    end
  end

  resources :namespaces, path: '/', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:show, :destroy] do
    resources :repositories, path: '/', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:new, :show, :create, :update, :destroy] do
      member do
        get 'settings', to: 'repositories#settings'
        get 'settings/collaborators', to: 'repositories#collaborators'
      end

      resources :tags, constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :destroy]
    end
  end

end
