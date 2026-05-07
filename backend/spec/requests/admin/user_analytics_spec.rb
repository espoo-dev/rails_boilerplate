# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::UserAnalytics" do
  describe "GET /admin/user_analytics" do
    context "when not authenticated" do
      before { get "/admin/user_analytics" }

      it { expect(response).to have_http_status(:redirect) }
    end

    context "when authenticated as non-admin" do
      let(:user) { create(:user) }

      before do
        sign_in user
        get "/admin/user_analytics"
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "when authenticated as admin" do
      let(:admin) { create(:user, admin: true) }

      before { sign_in admin }

      context "without date params" do
        before { get "/admin/user_analytics" }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("User Analytics") }
        it { expect(response.body).to include("Total Users") }
        it { expect(response.body).to include("growthChart") }
      end

      context "with date params" do
        before do
          get "/admin/user_analytics", params: { start_date: 7.days.ago.to_date.to_s, end_date: Date.current.to_s }
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include("User Analytics") }
      end

      context "with users created across days" do
        before do
          create(:user, created_at: 2.days.ago)
          create(:user, created_at: 1.day.ago)
          get "/admin/user_analytics"
        end

        it { expect(response).to have_http_status(:ok) }

        it "includes the total user count" do
          expect(response.body).to include(User.count.to_s)
        end
      end

      context "with invalid date params" do
        before do
          get "/admin/user_analytics", params: { start_date: "invalid", end_date: "also-invalid" }
        end

        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end
