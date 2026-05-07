# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  namespace :admin do
    resources :daily_overview, only: [:index]
    resources :user_lookup, only: [:index]
    resources :requests_dashboard, only: [:index]
    resources :user_analytics, only: [:index]
    resources :api_error_logs, only: [:index]
    resources :request_logs_by_payload, only: [:index] do
      collection do
        get :details
      end
    end
    resources :api_request_logs
    resources :users

    root to: "users#index"
  end
  extend DemoPackRoutes
  extend OauthRoutes

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post "/import", to: "handle_file#import"
      resources :users, only: %i[index create]
      resources :schools, only: %i[index]
    end
  end

  devise_scope :user do
    post "/api/v1/tokens", to: "devise/api/tokens#sign_in", as: "api_v1_sign_in_user_token"
  end
end
