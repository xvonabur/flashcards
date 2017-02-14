# frozen_string_literal: true
Rails.application.routes.draw do
  root to: redirect('/login')
  resources :cards
  resources :users
  resources :user_sessions, only: [:new, :create, :destroy]
  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout

  get '/translation_check' => 'translation_check#show', as: 'translation_check'
  post '/translation_check',
       to: 'translation_check#create', as: 'create_translation_check'

end
