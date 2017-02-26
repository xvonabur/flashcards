# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback' # for use with Facebook
  get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider

  root to: redirect('/login')
  resources :cards
  resources :decks
  resources :users
  resources :user_sessions, only: [:new, :create, :destroy]
  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout

  get '/translation_check' => 'translation_check#show', as: 'translation_check'
  post '/translation_check',
       to: 'translation_check#create', as: 'create_translation_check'

  mount Sidekiq::Web => '/sidekiq'
end
