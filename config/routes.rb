# frozen_string_literal: true

Rails.application.routes.draw do
  apipie
  devise_for :users, skip: [:registrations, :sessions, :passwords]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'check', to: 'tests#check'
      devise_scope :user do
        post 'sign_up', to: 'registrations#create'
        post 'sign_in', to: 'sessions#create'
      end

      resources :links, only: [:index, :create, :destroy]
    end
  end

  get 's/:slug', to: 'links#show', as: :shorten

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
