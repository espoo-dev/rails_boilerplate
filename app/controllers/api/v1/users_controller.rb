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

      def page
        params[:page]
      end

      def per_page
        params[:per_page]
      end
    end
  end
end
