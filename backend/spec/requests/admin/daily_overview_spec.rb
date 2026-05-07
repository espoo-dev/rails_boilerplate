# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::DailyOverview" do
  describe "GET /admin/daily_overview" do
    context "when not authenticated" do
      before { get "/admin/daily_overview" }

      it { expect(response).to have_http_status(:redirect) }
    end

    context "when authenticated as non-admin" do
      let(:user) { create(:user) }

      before do
        sign_in user
        get "/admin/daily_overview"
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when authenticated as admin" do
      let(:admin) { create(:user, admin: true) }

      before { sign_in admin }

      context "without params" do
        before { get "/admin/daily_overview" }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("Daily Overview") }
        it { expect(response.body).to include("Users") }
        it { expect(response.body).to include("API Request Logs") }

        it "renders one chart canvas per tracked entity" do
          %w[users api-request-logs].each do |slug|
            expect(response.body).to include(%(id="chart-#{slug}"))
          end
        end
      end

      context "with days param" do
        before { get "/admin/daily_overview", params: { days: 7 } }

        it { expect(response).to have_http_status(:ok) }
      end

      context "with out-of-range days param" do
        before { get "/admin/daily_overview", params: { days: 9999 } }

        it { expect(response).to have_http_status(:ok) }
      end

      context "with data across entities" do
        let(:user) { create(:user) }

        before do
          travel_to Time.zone.parse("2026-03-15 12:00:00") do
            create(
              :api_request_log, user: user, created_at: Time.current, started_at: Time.current,
              ended_at: 1.second.from_now
            )
            get "/admin/daily_overview"
          end
        end

        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end
