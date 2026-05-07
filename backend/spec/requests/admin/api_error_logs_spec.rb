# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::ApiErrorLogs" do
  describe "GET /admin/api_error_logs" do
    context "when not authenticated" do
      before { get "/admin/api_error_logs" }

      it { expect(response).to have_http_status(:redirect) }
    end

    context "when authenticated as non-admin" do
      let(:user) { create(:user) }

      before do
        sign_in user
        get "/admin/api_error_logs"
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when authenticated as admin" do
      let(:admin) { create(:user, admin: true) }
      let(:target_user) { create(:user) }
      let(:t0) { Time.zone.parse("2026-03-23 10:00:00") }
      let(:travel_time) { Time.zone.parse("2026-04-01 12:00:00") }

      before do
        sign_in admin
        travel_to travel_time
      end

      context "with no non-2xx logs" do
        before { get "/admin/api_error_logs" }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("No non-2xx API request logs found.") }
      end

      context "with non-2xx logs" do
        before do
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/old", response_code: 500,
            started_at: t0, ended_at: t0 + 1.second, duration_ms: 100
          )
          create(
            :api_request_log, user: target_user, http_method: "POST",
            endpoint: "/api/v1/newer", response_code: 404,
            started_at: t0 + 2.hours, ended_at: t0 + 2.hours + 1.second, duration_ms: 50
          )
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/older-404", response_code: 404,
            started_at: t0 + 1.hour, ended_at: t0 + 1.hour + 1.second, duration_ms: 75
          )
          get "/admin/api_error_logs"
        end

        it { expect(response).to have_http_status(:ok) }

        it "orders groups by most recent activity first" do
          pos_404 = response.body.index("HTTP 404")
          pos_500 = response.body.index("HTTP 500")
          expect(pos_404).to be < pos_500
        end

        it "orders rows within a group newest first" do
          newer = response.body.index("/api/v1/newer")
          older = response.body.index("/api/v1/older-404")
          expect(newer).to be < older
        end

        it "includes administrate detail links" do
          log = ApiRequestLog.find_by(endpoint: "/api/v1/newer")
          expect(response.body).to include(admin_api_request_log_path(log))
        end
      end

      context "with filters" do
        let(:other_user) { create(:user, email: "someone.else@example.com") }

        before do
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/match", response_code: 500,
            started_at: t0, ended_at: t0 + 1.second, duration_ms: 100
          )
          create(
            :api_request_log, user: other_user, http_method: "GET",
            endpoint: "/api/v1/other-user", response_code: 500,
            started_at: t0, ended_at: t0 + 1.second, duration_ms: 100
          )
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/old-date", response_code: 500,
            started_at: t0 - 10.days, ended_at: t0 - 10.days + 1.second, duration_ms: 100
          )
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/new-date", response_code: 500,
            started_at: t0 + 10.days, ended_at: t0 + 10.days + 1.second, duration_ms: 100
          )
        end

        it "filters by partial user email (ILIKE)" do
          get "/admin/api_error_logs", params: { email: target_user.email.split("@").first }
          expect(response.body).to include("/api/v1/match")
          expect(response.body).not_to include("/api/v1/other-user")
        end

        it "filters case-insensitively by email" do
          get "/admin/api_error_logs", params: { email: target_user.email.upcase }
          expect(response.body).to include("/api/v1/match")
          expect(response.body).not_to include("/api/v1/other-user")
        end

        it "filters by start_date (inclusive)" do
          get "/admin/api_error_logs", params: { start_date: t0.to_date.iso8601 }
          expect(response.body).to include("/api/v1/match")
          expect(response.body).to include("/api/v1/new-date")
          expect(response.body).not_to include("/api/v1/old-date")
        end

        it "filters by end_date (inclusive)" do
          get "/admin/api_error_logs", params: { end_date: t0.to_date.iso8601 }
          expect(response.body).to include("/api/v1/match")
          expect(response.body).to include("/api/v1/old-date")
          expect(response.body).not_to include("/api/v1/new-date")
        end

        it "combines email + date range filters" do
          get "/admin/api_error_logs", params: {
            email: target_user.email,
            start_date: t0.to_date.iso8601,
            end_date: t0.to_date.iso8601
          }
          aggregate_failures do
            expect(response.body).to include("/api/v1/match")
            expect(response.body).not_to include("/api/v1/other-user")
            expect(response.body).not_to include("/api/v1/old-date")
            expect(response.body).not_to include("/api/v1/new-date")
          end
        end

        it "ignores invalid date strings without raising" do
          get "/admin/api_error_logs", params: { start_date: "not-a-date", end_date: "also-bad" }
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("/api/v1/match")
        end

        it "renders the Clear link when filters are active" do
          get "/admin/api_error_logs", params: { email: "gmail" }
          expect(response.body).to include(">Clear</a>")
        end

        it "renders the Clear link by default since date defaults are always applied" do
          get "/admin/api_error_logs"
          expect(response.body).to include(">Clear</a>")
        end

        it "renders the Clear link when only the app_version filter is active" do
          get "/admin/api_error_logs", params: { app_version: "1.2.3" }
          expect(response.body).to include(">Clear</a>")
        end
      end

      context "with default date filters" do
        before { get "/admin/api_error_logs" }

        it "preselects from = 30 days ago" do
          expected = (travel_time.to_date - 30).iso8601
          expect(response.body).to include(%(value="#{expected}"))
        end

        it "preselects to = tomorrow" do
          expected = (travel_time.to_date + 1).iso8601
          expect(response.body).to include(%(value="#{expected}"))
        end
      end

      context "with chart axis covering the full date range" do
        before do
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/just-one", response_code: 500,
            started_at: t0, ended_at: t0 + 1.second, duration_ms: 100
          )
          get "/admin/api_error_logs", params: {
            start_date: "2026-03-20", end_date: "2026-03-25"
          }
        end

        it "includes every day in the selected range as a chart label" do
          %w[2026-03-20 2026-03-21 2026-03-22 2026-03-23 2026-03-24 2026-03-25].each do |day|
            expect(response.body).to include(day)
          end
        end
      end

      context "with logs from multiple app versions" do
        before do
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/from-1-2-3", response_code: 500,
            started_at: t0, ended_at: t0 + 1.second, duration_ms: 100,
            headers: { "App-Version" => "1.2.3" }
          )
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/from-1-2-4", response_code: 500,
            started_at: t0 + 1.hour, ended_at: t0 + 1.hour + 1.second, duration_ms: 100,
            headers: { "App-Version" => "1.2.4" }
          )
          create(
            :api_request_log, user: target_user, http_method: "GET",
            endpoint: "/api/v1/from-unknown", response_code: 500,
            started_at: t0 + 2.hours, ended_at: t0 + 2.hours + 1.second, duration_ms: 100,
            headers: {}
          )
        end

        it "renders an option for each known app version plus 'unknown'" do
          get "/admin/api_error_logs"

          expect(response.body).to include('<option value="1.2.3"')
          expect(response.body).to include('<option value="1.2.4"')
          expect(response.body).to include('<option value="unknown"')
        end

        it "filters logs to a specific app version" do
          get "/admin/api_error_logs", params: { app_version: "1.2.3" }

          expect(response.body).to include("/api/v1/from-1-2-3")
          expect(response.body).not_to include("/api/v1/from-1-2-4")
          expect(response.body).not_to include("/api/v1/from-unknown")
        end

        it "filters to logs without an App-Version header when 'unknown' is selected" do
          get "/admin/api_error_logs", params: { app_version: "unknown" }

          expect(response.body).to include("/api/v1/from-unknown")
          expect(response.body).not_to include("/api/v1/from-1-2-3")
          expect(response.body).not_to include("/api/v1/from-1-2-4")
        end

        it "preselects the chosen app version in the dropdown" do
          get "/admin/api_error_logs", params: { app_version: "1.2.4" }

          expect(response.body).to include('<option value="1.2.4" selected>1.2.4</option>')
        end

        it "shows a clear-filter badge when filtered" do
          get "/admin/api_error_logs", params: { app_version: "1.2.3" }

          expect(response.body).to include("Filtered: 1.2.3")
        end

        it "shows a filter-aware empty-state message when nothing matches" do
          get "/admin/api_error_logs", params: { app_version: "9.9.9" }

          expect(response.body).to include("No non-2xx API request logs found for app version 9.9.9.")
        end
      end
    end
  end
end
