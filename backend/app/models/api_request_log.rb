# frozen_string_literal: true

class ApiRequestLog < ApplicationRecord
  belongs_to :user, optional: true

  validates :http_method, :endpoint, :response_code, :started_at, :ended_at, :duration_ms, presence: true

  def summary
    <<~TEXT
      On a request with http method #{http_method} and endpoint #{endpoint}, the response code is #{response_code} and the response body is:

      #{response}

      The request payload is:

      #{payload}

      The request headers are:

      #{headers}
    TEXT
  end
end
