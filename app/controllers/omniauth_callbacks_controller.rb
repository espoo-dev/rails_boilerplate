# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.find_or_create_from_oauth_provider_data(request.env["omniauth.auth"])
    if user.persisted?
      sign_in_and_redirect user
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end
end
