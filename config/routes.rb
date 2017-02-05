# frozen_string_literal: true
Rails.application.routes.draw do
  root to: "static_pages#home"
  resources :cards, only: [:index, :show]
end
