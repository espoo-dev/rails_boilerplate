# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::UserLookup" do
  describe "GET /admin/user_lookup" do
    context "when not authenticated" do
      before { get "/admin/user_lookup" }

      it { expect(response).to have_http_status(:redirect) }
    end

    context "when authenticated as non-admin" do
      let(:user) { create(:user) }

      before do
        sign_in user
        get "/admin/user_lookup"
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when authenticated as admin" do
      let(:admin) { create(:user, admin: true) }

      before { sign_in admin }

      context "without email param" do
        before { get "/admin/user_lookup" }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("User Lookup") }
      end

      context "with latest active users panel" do
        let!(:older_user) { create(:user, email: "older@example.com") }
        let!(:newer_user) { create(:user, email: "newer@example.com") }

        before do
          create(
            :api_request_log, user: older_user,
            started_at: 2.days.ago, ended_at: 2.days.ago + 1.second, duration_ms: 50
          )
          create(
            :api_request_log, user: newer_user,
            started_at: 1.hour.ago, ended_at: 1.hour.ago + 1.second, duration_ms: 50
          )
          get "/admin/user_lookup"
        end

        it { expect(response.body).to include("Latest Active Users") }
        it { expect(response.body).to include(older_user.email) }
        it { expect(response.body).to include(newer_user.email) }

        it "orders newer activity before older activity" do
          expect(response.body.index(newer_user.email)).to be < response.body.index(older_user.email)
        end
      end

      context "with email that does not match any user" do
        before { get "/admin/user_lookup", params: { email: "nonexistent@email.com" } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("No user found") }
      end

      context "with email matching a user" do
        let(:user) { create(:user) }

        before do
          create(
            :api_request_log, user: user, http_method: "GET",
            endpoint: "/api/v1/test", response_code: 200,
            started_at: 1.hour.ago, ended_at: 1.hour.ago + 1.second, duration_ms: 100
          )
          get "/admin/user_lookup", params: { email: user.email }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include(user.email) }
        it { expect(response.body).to include("API Logs") }
        it { expect(response.body).to include("Last API Activity") }
        it { expect(response.body).to include("Inactive Days") }
        it { expect(response.body).to include("/api/v1/test") }
      end

      context "with case-insensitive email search" do
        let(:user) { create(:user) }

        before { get "/admin/user_lookup", params: { email: user.email.upcase } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include(user.email) }
      end
    end
  end
end
