module Api
  module V1
    class UsersController < Api::ApplicationController
      def index
        @users = User.all
        render json: @users, status: :ok
      end
    end
  end
end