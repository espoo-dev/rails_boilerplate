# frozen_string_literal: true

module Users
  IndexSchema = Dry::Schema.Params do
    config.messages.backend = :i18n

    optional(:page).filled(:integer)
    optional(:per_page).filled(:integer)
  end

  CreateSchema = Dry::Schema.Params do
    config.messages.backend = :i18n

    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
