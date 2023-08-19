# frozen_string_literal: true

Rails.application.routes.draw do
  resources :dashboards
  root 'sessions#new'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
end
