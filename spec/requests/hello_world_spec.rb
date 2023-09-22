require 'rails_helper'

RSpec.describe "HelloWorlds", type: :request do
  describe "GET /public_method" do
    before { get "/public_method" }

    it 'should render message' do
      expect(response.body).to eq("This method does not need authentication")
    end
  end
end
