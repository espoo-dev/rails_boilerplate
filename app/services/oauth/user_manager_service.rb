# frozen_string_literal: true

module Oauth
  class UserManagerService
    ALLOWED_PROVIDERS_HASH = {
      github: "github",
      strava: "strava"
    }.freeze

    ALLOWED_PROVIDERS = %w[github strava].freeze

    def find_or_create_from_oauth_provider(oauth_provider_data)
      oauth_provider = oauth_provider_data.provider || oauth_provider_data.oauth_provider

      case oauth_provider
      when ALLOWED_PROVIDERS_HASH[:github]
        find_or_create_user(oauth_provider_data, "github", oauth_provider_data.info.email)
      when ALLOWED_PROVIDERS_HASH[:strava]
        find_or_create_user(
          oauth_provider_data, ALLOWED_PROVIDERS_HASH[:strava],
          strava_generated_email(oauth_provider_data)
        )
      else
        raise "invalid oauth provider (#{oauth_provider}), it must be included in [#{ALLOWED_PROVIDERS.join(',')}]"
      end
    end

    private

    def strava_generated_email(oauth_provider_data)
      "#{oauth_provider_data.uid}@strava_unknown_email.com"
    end

    def find_or_create_user(oauth_provider_data, oauth_provider, email)
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
