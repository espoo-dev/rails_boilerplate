# frozen_string_literal: true

module Users
  IndexSchema = Dry::Schema.Params do
    optional(:page).filled(:integer)
    optional(:per_page).filled(:integer)
  end
end
