module Oauth
  class UserManager
    def find_or_create_from_oauth_provider(oauth_provider_data)
      oauth_provider = oauth_provider_data.provider || oauth_provider_data.oauth_provider

      case oauth_provider
      when "github"
        find_or_create_from_oauth_provider_data(oauth_provider_data, "github", oauth_provider_data.info.email)
      when "strava"
        find_or_create_from_oauth_provider_data(
          oauth_provider_data, "strava",
          strava_generated_email(oauth_provider_data)
        )
      else
        raise "invalid oauth provider (#{oauth_provider}), it must be included in #{Oauth::ALLOWED_PROVIDERS} "
      end
    end

    private

    def strava_generated_email(oauth_provider_data)
      "#{oauth_provider_data.uid}@strava_unknown_email.com"
    end

    def find_or_create_from_oauth_provider_data(oauth_provider_data, oauth_provider, email)
      User.where(
        oauth_provider: oauth_provider,
        oauth_uid: oauth_provider_data.uid
      ).first_or_create do |user|
        user.email = email
        user.password = Devise.friendly_token[0, 20]
      end
    end
  end
end
