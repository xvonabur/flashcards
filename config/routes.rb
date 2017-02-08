# frozen_string_literal: true
Rails.application.routes.draw do
  root to: "translation_check#show"
  resources :cards
  post '/translation_check',
       to: 'translation_check#create', as: 'create_translation_check'

end
