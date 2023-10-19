# frozen_string_literal: true

class User < ApplicationRecord
  update_index("users") { self }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :api,
    :omniauthable, omniauth_providers: %i[github strava]

  validates :email, uniqueness: { case_sensitive: false }
end
