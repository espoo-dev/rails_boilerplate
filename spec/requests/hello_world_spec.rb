# frozen_string_literal: true

require "rails_helper"

RSpec.describe "HelloWorlds" do
  describe "GET /public_method" do
    before { get "/public_method" }

    it "renders message" do
      expect(response.body).to eq("This method does not need authentication")
    end
  end

  describe "GET /private_method" do
    let(:user) { create(:user) }

    before do
      sign_in user
      get "/private_method"
    end

    it "renders message" do
      expect(response.body).to eq("This method needs authentication")
    end
  end
end
