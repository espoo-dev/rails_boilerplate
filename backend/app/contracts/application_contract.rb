# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = :en
  config.messages.backend = :i18n

  def self.call(args)
    instance = self.new.call(args)

    if instance.errors.messages.any?
      error_message = instance.errors.to_h.map { _1[1].join(", ") }.join(", ")
      raise InvalidContractError, error_message
    end

    instance.to_h
  end
end
