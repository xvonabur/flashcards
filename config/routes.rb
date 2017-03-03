# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :home do
    resources :user_sessions, only: [:new, :create]
    resources :users, only: [:index, :new, :create]
  end

  namespace :dashboard do
    resources :cards
    resources :decks
    get '/translation_check' => 'translation_check#show', as: 'translation_check'
    post '/translation_check',
         to: 'translation_check#create', as: 'create_translation_check'
    resources :user_sessions, only: :destroy
    resources :users, only: [:edit, :update, :destroy]
  end

  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback' # for use with Facebook
  get 'oauth/:provider' => 'oauths#oauth', as: :auth_at_provider
  get 'login' => 'home/user_sessions#new', as: :login
  post 'logout' => 'dashboard/user_sessions#destroy', as: :logout

  mount Sidekiq::Web => '/sidekiq'
  root to: redirect('/login')
end
