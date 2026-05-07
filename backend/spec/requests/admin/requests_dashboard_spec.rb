# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::RequestsDashboard" do
  describe "GET /admin/requests_dashboard" do
    context "when not authenticated" do
      before { get "/admin/requests_dashboard" }

      it { expect(response).to have_http_status(:redirect) }
    end

    context "when authenticated as non-admin" do
      let(:user) { create(:user) }

      before do
        sign_in user
        get "/admin/requests_dashboard"
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when authenticated as admin" do
      let(:admin) { create(:user, admin: true) }

      before { sign_in admin }

      context "without user_id param" do
        before { get "/admin/requests_dashboard" }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("Search by email") }
        it { expect(response.body).to include("or pick user") }
      end

      context "with email param matching a user" do
        let(:target_user) { create(:user, email: "needle@example.com") }

        before do
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/needle", response_code: 200,
            started_at: 1.hour.ago, ended_at: 1.hour.ago + 1.second, duration_ms: 50
          )
          get "/admin/requests_dashboard", params: { email: "needle" }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include(target_user.email) }
        it { expect(response.body).to include("/api/v1/needle") }
      end

      context "with email param matching no user" do
        before { get "/admin/requests_dashboard", params: { email: "nobody@example.com" } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include('No user matched "nobody@example.com"') }
      end

      context "with user_id param" do
        let(:target_user) { create(:user) }
        let(:now) { Time.zone.parse("2026-03-23 10:00:00") }

        before do
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/users", response_code: 200,
            started_at: now, ended_at: now + 1.second, duration_ms: 100
          )
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/users", response_code: 200,
            started_at: now + 1.hour, ended_at: now + 1.hour + 1.second, duration_ms: 150
          )
          create(
            :api_request_log, user: target_user, http_method: "POST",
            endpoint: "/api/v1/users", response_code: 500,
            started_at: now + 2.hours, ended_at: now + 2.hours + 1.second, duration_ms: 200
          )
          get "/admin/requests_dashboard", params: { user_id: target_user.id }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("2xx Requests") }
        it { expect(response.body).to include("Non-2xx Requests") }
        it { expect(response.body).to include(target_user.email) }

        it "shows grouped request counts" do
          expect(response.body).to include("/api/v1/users")
        end

        it "shows non-2xx requests in error table" do
          expect(response.body).to include("500")
        end
      end
    end
  end
end
