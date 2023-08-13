# frozen_string_literal: true

Rails.application.routes.draw do
  root "sessions#new"

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'

  get 'tasks', to: 'tasks#index', as: 'tasks'
end
