# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApiController
      skip_before_action :authenticate_devise_api_token!, only: :create

      def index
        users = User.page(page).per(per_page)

        authorize(users)

        render json: users, status: :ok
      end

      def create
        user = User.new(user_create_schema)

        authorize(user)

        user.save!

        render json: user, status: :created
      end

      private

      def user_index_schema
        @user_index_schema ||= Users::IndexSchema.call(params.permit(:page, :per_page).to_h)
      end

      def user_create_schema
        permitted_params = params.permit(:email, :password).to_h.with_indifferent_access
        @create_user_contract ||= CreateUserContract.new.call(permitted_params)
        if @create_user_contract.errors.messages.any?
          error_message = @create_user_contract.errors.to_h.map { _1[1].join(", ") }.join(", ")
          raise InvalidContractError, error_message
        end
        @create_user_contract.to_h
      end

      def page
        user_index_schema.output[:page]
      end

      def per_page
        user_index_schema.output[:per_page]
      end
    end
  end
end
