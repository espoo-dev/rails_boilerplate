# frozen_string_literal: true

require "rails_helper"

RSpec.describe FetchSchools, type: :actor do
  describe ".call" do
    let(:school_name) { "The best school" }

    context "when setup is valid" do
      let(:valid_params) do
        {
          api_key:,
          fields: "id,school.name",
          page: 0,
          "school.name" => school_name
        }
      end

      let(:success_response) { { results: schools }.to_json }

      let(:schools) do
        [
          { "id" => "1",
            "school.name" => school_name }
        ]
      end

      let(:api_key) { "secret_api_key" }

      before do
        allow_any_instance_of(described_class).to receive(:api_key).and_return(api_key)
        stub_request(:get, described_class::FETCH_SCHOOLS_URL)
          .with(query: valid_params)
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
      end

      it "is successful" do
        result = described_class.result(school_name_like: school_name)
        expect(result.success?).to be true
      end

      it "returns schools list" do
        result = described_class.result(school_name_like: school_name)
        expect(result.data).to eq(schools)
      end
    end

    context "when setup is not valid" do
      context "when api_key is nil" do
        before do
          allow_any_instance_of(described_class).to receive(:api_key).and_return("")
        end

        it "is failure" do
          result = described_class.result(school_name_like: school_name)
          expect(result.failure?).to be true
        end
      end

      it "returns error object" do
        result = described_class.result(school_name_like: school_name)
        expect(result.error).to eq(:missing_college_score_card_api_key)
      end
    end
  end
end
