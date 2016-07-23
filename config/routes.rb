Rails.application.routes.draw do
  get 'dashboard', to: 'dashboard#index'

  devise_for :users
  root to: 'home#index'

  post 'service/notifications'
  get 'service/token'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
