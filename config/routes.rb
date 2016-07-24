Rails.application.routes.draw do

  resources :dashboard, controller: 'dashboard', only: [:index]

  devise_for :users
  root to: 'home#index'

  post 'service/notifications'
  get 'service/token'

  resources :namespaces, path: '/n', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:new, :create, :destroy, :edit] do
    member do
      get 'teams'
      get 'settings'
    end
  end

  resources :namespaces, path: '/', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:show] do
    resources :repositories, path: '/', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:new, :show, :update, :destroy] do
      member do
        get 'tags'
        get 'settings', to: 'repositories#settings'
        get 'settings/collaborators', to: 'repositories#collaborators'
      end
    end
  end

end
