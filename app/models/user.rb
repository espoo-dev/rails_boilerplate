# frozen_string_literal: true

class User < ApplicationRecord
  update_index("users") { self }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :api,
    :omniauthable, omniauth_providers: %i[github strava]

  validates :email, uniqueness: { case_sensitive: false }

  def self.find_or_create_from_oauth_provider_data(oauth_provider_data)
    where(
      oauth_provider: oauth_provider_data.oauth_provider,
      oauth_uid: oauth_provider_data.uid
    ).first_or_create do |user|
      user.email = oauth_provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.find_or_create_from_strava_oauth_provider_data(oauth_provider_data)
    where(
      oauth_provider: oauth_provider_data.provider,
      oauth_uid: oauth_provider_data.uid
    ).first_or_create do |user|
      user.email = "#{oauth_provider_data.uid}@strava_unknown_email.com"
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
