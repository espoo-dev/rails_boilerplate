# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def index
        users = User.page(page).per(per_page)

        authorize(users)

        render json: users, status: :ok
      end

      private

      def user_index_schema
        @user_index_schema ||= Users::IndexSchema.call(params.permit(:page, :per_page).to_h)
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
