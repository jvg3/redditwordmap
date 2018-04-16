Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'word_map#index'
  resources :word_map, only: [:index]

  mount Sidekiq::Web => '/sidekiq'
end