Rails.application.routes.draw do
  post 'github/event_handler'

  get 'pages/index'

  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#index'

  resources :users
  resources :pages
  resources :accounts

  resource :site, only: :new
  resources :sites
end
