# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth_sign_in
  end

  def strava
    oauth_sign_in
  end

  def oauth_sign_in
    user = Oauth::UserManagerService.new.find_or_create_from_oauth_provider(request.env["omniauth.auth"])
    if user.persisted?
      sign_in_and_redirect user
    else
      redirect_to new_user_registration_url
    end
  end
end
