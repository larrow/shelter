Rails.application.routes.draw do

  namespace :admin do
    resource :setting, only: [:edit, :update]
    resources :users
    resources :namespaces
    resources :repositories
  end

  resources :dashboard, only: [:index]

  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'

  post 'service/notifications'
  get  'service/token'
  put  'service/sync'
  get  'search', to: 'search#index'

  resources :namespaces, path: '/n', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:show, :create, :new, :destroy] do
    resources :members, constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :create, :new, :destroy] do
      member do
        post 'toggle_access_level'
      end
    end

    member do
      get 'settings'
    end

    resources :repositories, path: '/r', constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:show, :update, :destroy] do
      member do
        post 'toggle_publicity'
        get 'edit_description'
      end

      resources :tags, constraints: { id: /[a-zA-Z.0-9_\-]+/ }, only: [:index, :destroy]
    end
  end

end
