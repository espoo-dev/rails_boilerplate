# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiRequestLoggerMiddleware do
  subject(:middleware) { described_class.new(app) }

  let(:app) { ->(_env) { [200, { "Content-Type" => "application/json" }, ["{}"]] } }

  describe "private fallback branches" do
    it "stores raw payload when content-type is json but body is invalid json" do
      env = Rack::MockRequest.env_for(
        "/api/v1/test",
        method: "POST",
        "CONTENT_TYPE" => "application/json",
        input: "{invalid-json"
      )
      request = ActionDispatch::Request.new(env)

      expect(middleware.send(:parse_body, request)).to eq(raw: "{invalid-json")
    end

    it "returns nil body when response body is blank" do
      payload = middleware.send(:build_response_payload, 204, "")

      expect(payload).to eq(status: 204, body: nil)
    end

    it "stores raw response when response body is not json" do
      payload = middleware.send(:build_response_payload, 200, "plain text response")

      expect(payload).to eq(status: 200, body: "plain text response")
    end
  end
end
