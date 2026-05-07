# frozen_string_literal: true

FactoryBot.define do
  factory :api_request_log do
    user
    http_method { "GET" }
    endpoint { "/api/v1/users" }
    response_code { 200 }
    started_at { Time.current }
    ended_at { 0.1.seconds.from_now }
    duration_ms { 100 }
  end
end
