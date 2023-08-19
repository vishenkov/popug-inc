# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'

  resources :tasks
  post 'tasks/shuffle', to: 'tasks#shuffle', as: 'shuffle_tasks'
end
