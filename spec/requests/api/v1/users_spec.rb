# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  describe "GET /api/v1/users" do
    context "when has user" do
      let!(:user) { create(:user) }

      before do
        get "/api/v1/users"
      end

      it { expect(response.parsed_body.first).to have_key("id") }
      it { expect(response.parsed_body.first).to have_key("email") }
      it { expect(response.parsed_body.first["email"]).to eq(user.email) }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when does not have user" do
      before do
        get "/api/v1/users"
      end

      it { expect(response.parsed_body.empty?).to be(true) }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
