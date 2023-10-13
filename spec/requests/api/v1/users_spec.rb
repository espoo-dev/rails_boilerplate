# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  describe "GET /api/v1/users" do
    context 'when has user' do
      let!(:user) { create(:user) }

      before do
        get "/api/v1/users"
        @parsed_body = JSON.parse(response.body)
      end

      it "renders json with user" do
        expect(@parsed_body.first).to have_key("id")
        expect(@parsed_body.first).to have_key("email")
        expect(@parsed_body.first["email"]).to eq(user.email)
      end

      it "receives http status ok" do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when does not have user' do
      before do
        get "/api/v1/users"
        @parsed_body = JSON.parse(response.body)
      end

      it "renders json with user" do
        expect(@parsed_body.empty?).to eq(true)
      end

      it "receives http status ok" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
