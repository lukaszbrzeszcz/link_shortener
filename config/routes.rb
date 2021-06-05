Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :sessions, :passwords]
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get "check", to: "tests#check"
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
      end
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
