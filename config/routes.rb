# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/public_method", to: "hello_world#public_method"
  get "/private_method", to: "hello_world#private_method"
  get "/search", to: "hello_world#search"

  namespace :api, defaults: { format: :json } do
    get "/public_method", to: "hello_world#public_method"
    get "/private_method", to: "hello_world#private_method"
  end
end
