Rails.application.routes.draw do
  root 'word_map#index'

  resources :word_map, only: [:index]
end