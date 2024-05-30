# frozen_string_literal: true

class CreateUserContract < ApplicationContract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end
