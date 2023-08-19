# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  root 'users#index'
  resources :users, only: [:edit, :update, :destroy]
  get '/users/current', to: 'users#current'
end
