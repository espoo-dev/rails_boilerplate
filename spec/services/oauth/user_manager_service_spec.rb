# frozen_string_literal: true

require "rails_helper"

RSpec.describe Oauth::UserManagerService do
  describe "#find_or_create_user" do
    let(:uid) { "1234" }
    let(:oauth_provider_data) do
      OmniAuth::AuthHash.new(
        {
          oauth_provider:,
          uid:
        }
      )
    end

    context "when oauth_provider is strava" do
      let(:oauth_provider) { "strava" }

      before { described_class.new.find_or_create_from_oauth_provider(oauth_provider_data) }

      it "creates strava user", :agreggate_failures do
        user = User.first
        expect(user.oauth_uid).to eq(uid)
        expect(user.oauth_provider).to eq(oauth_provider)
        expect(user.email).to eq("1234@strava_unknown_email.com")
      end
    end

    context "when oauth_provider is not supported" do
      let(:oauth_provider) { "facebook" }

      it "raises an error", :agreggate_failures do
        expect do
          described_class.new.find_or_create_from_oauth_provider(oauth_provider_data)
        end.to raise_error("invalid oauth provider (facebook), it must be included in [github,strava]")
      end
    end
  end
end
