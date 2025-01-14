# frozen_string_literal: true

require "rails_helper"

RSpec.describe FetchSchools, type: :actor do
  describe ".call" do
    let(:school_name) { "The best school" }
    let(:valid_params) do
      {
        api_key:,
        fields: "id,school.name,location",
        page: 0,
        "school.name" => school_name
      }
    end

    let(:school_index_contract) { SchoolContracts::Index.call({ school_name_like: school_name }) }

    let(:success_response) { { results: schools }.to_json }

    let(:schools) do
      [
        { "id" => "1",
          "school.name" => school_name,
          "location.lat" => 42.374471,
          "location.lon" => -71.118313 }
      ]
    end

    let(:api_key) { "secret_api_key" }

    let(:call) { described_class.result(school_index_contract:) }

    before do
      allow_any_instance_of(described_class).to receive(:api_key).and_return(api_key)
      stub_request(:get, described_class::FETCH_SCHOOLS_URL)
        .with(query: valid_params)
        .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
    end

    context "when setup is valid" do

      it "is successful" do
        expect(call.success?).to be true
      end

      it "returns schools list" do
        expect(call.data).to eq(schools)
      end
    end

    context "when setup is not valid" do
      context "when api_key is nil" do
        before do
          allow_any_instance_of(described_class).to receive(:api_key).and_return("")
        end

        it "is failure" do
          expect(call.failure?).to be true
        end

        it "returns error object" do
          expect(call.error).to eq(:missing_college_score_card_api_key)
        end
      end
    end
  end
end
