# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::RequestLogsByPayload" do
  describe "GET /admin/request_logs_by_payload" do
    context "when not authenticated" do
      before { get "/admin/request_logs_by_payload" }

      it { expect(response).to have_http_status(:redirect) }
    end

    context "when authenticated as non-admin" do
      let(:user) { create(:user) }

      before do
        sign_in user
        get "/admin/request_logs_by_payload"
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when authenticated as admin" do
      let(:admin) { create(:user, admin: true) }
      let(:target_user) { create(:user, email: "doctor@example.com") }
      let(:t0) { 2.days.ago.change(hour: 10) }

      before { sign_in admin }

      context "with no non-2xx logs" do
        before { get "/admin/request_logs_by_payload" }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("No non-2xx API request logs found.") }
      end

      context "with non-2xx logs" do
        let(:payload) { { "key" => "value" } }

        before do
          create(
            :api_request_log, user: target_user, http_method: "POST",
            endpoint: "/api/v1/users", response_code: 422,
            payload: payload, headers: { "App-Version" => "1.4.2" },
            started_at: t0, ended_at: t0 + 1.second, duration_ms: 100
          )
          create(
            :api_request_log, user: target_user, http_method: "POST",
            endpoint: "/api/v1/users", response_code: 500,
            payload: payload, headers: { "App-Version" => "1.4.2" },
            started_at: t0 + 1.hour, ended_at: t0 + 1.hour + 1.second, duration_ms: 50
          )
          get "/admin/request_logs_by_payload"
        end

        it { expect(response).to have_http_status(:ok) }

        it "displays the daily totals section" do
          expect(response.body).to include("Total non-2xx requests per day")
        end

        it "displays the grouped logs section" do
          expect(response.body).to include("Grouped by payload, response code, day, and user")
        end

        it "shows the user email" do
          expect(response.body).to include("doctor@example.com")
        end

        it "shows the payload content" do
          expect(response.body).to include("value")
        end

        it "shows an App version column header" do
          expect(response.body).to include("App version")
        end

        it "shows the App-Version from the request headers in the grouped table" do
          expect(response.body).to include("1.4.2")
        end
      end

      context "with logs older than 10 days" do
        before do
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/old", response_code: 500,
            started_at: 15.days.ago, ended_at: 15.days.ago + 1.second, duration_ms: 100
          )
          get "/admin/request_logs_by_payload"
        end

        it { expect(response).to have_http_status(:ok) }

        it "does not show old logs" do
          expect(response.body).to include("No non-2xx API request logs found.")
        end
      end

      context "with 2xx logs only" do
        before do
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/users", response_code: 200,
            started_at: t0, ended_at: t0 + 1.second, duration_ms: 50
          )
          get "/admin/request_logs_by_payload"
        end

        it { expect(response).to have_http_status(:ok) }

        it "does not show 2xx logs" do
          expect(response.body).to include("No non-2xx API request logs found.")
        end
      end
    end
  end
end
