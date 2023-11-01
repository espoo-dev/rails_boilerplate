# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  devise_for :users, controllers: { omniauth_callbacks: "oauth/controllers/omniauth_callbacks" }

  get "/public_method", to: "demo_pack/controllers/hello_world#public_method"
  get "/private_method", to: "demo_pack/controllers/hello_world#private_method"
  get "/search", to: "hello_world#search"

  get "api/v1/public_method", to: "demo_pack/controllers/api/v1/hello_world#public_method"
  get "api/v1/private_method", to: "demo_pack/controllers/api/v1/hello_world#private_method"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:index]
    end
  end
end
