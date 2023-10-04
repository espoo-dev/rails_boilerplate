# frozen_string_literal: true

require "rails_helper"

RSpec.describe "HelloWorlds" do
  describe "GET /public_method" do
    before { get "/api/public_method" }

    it "renders json with message" do
      expect(response.body).to include("This method does not need authentication")
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /private_method" do
    let(:user) { create(:user) }
    
    context "when user is not authenticated" do
      before do
        get "/api/private_method"
      end

      it "renders json with message" do
        expect(response.body).to include("error","Invalid token")
        expect(response).to have_http_status(401)
      end
    end

    # context "when user is authenticated" do
    #   let(:params) {{ email: user.email, passoword: user.password }}

    #   before do
    #     post "/users/tokens/sign_in", params: params, as: :json
    #     get "/api/private_method"
    #   end

    #   it "renders json with message" do
    #     expect(response.body).to include("This method needs authentication")
    #   end
    # end
  end
end