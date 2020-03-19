# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login
  # POST /auth/login
  def login
    user = User.find_by(username: login_params[:username])

    if user&.authenticate(login_params[:password])
      token = encode_user(user)
      time = Time.zone.now + 24.hours.to_i
      json = {
        token: token,
        exp: time.strftime('%m-%d-%Y %H:%M'),
        username: user.username,
        userId: user.id,
        accessLevel: user.access_level
      }
      render json: json, status: :ok
    else
      render_unauthorized
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
