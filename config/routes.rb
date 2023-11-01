# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  extend DemoPackRoutes
  extend OauthRoutes
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:index]
    end
  end
end
