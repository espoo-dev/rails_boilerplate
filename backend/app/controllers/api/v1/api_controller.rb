# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      include Pundit::Authorization
      after_action :verify_authorized

      before_action :authenticate_devise_api_token!

      rescue_from Pundit::NotAuthorizedError, with: :render_unauthorized
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      def current_user
        current_devise_api_user
      end

      def render_unauthorized(message = "Unauthorized")
        render json: { error: message }, status: :unauthorized
      end

      def render_unprocessable_entity(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
      end

      def render_not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end
    end
  end
end
