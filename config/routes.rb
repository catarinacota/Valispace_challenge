Rails.application.routes.draw do
  devise_for :users

  root to: 'functions#index'
  resources :functions, only: [:index]
  namespace :admin do
    resources :functions, :path => ''
  end
end


