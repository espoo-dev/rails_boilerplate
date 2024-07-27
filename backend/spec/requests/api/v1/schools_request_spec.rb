# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Schools" do
  describe "GET /api/v1/schools" do
    let(:do_request) { get "/api/v1/schools", params: }
    let(:result) { double("Result", data: schools) }
    let(:school_name_like) { "Harvard" }
    let(:schools) do
      [
        { "id" => "1",
          "school.name" => school_name_like,
          "location.lat" => 42.374471,
          "location.lon" => -71.118313 }
      ]
    end
    let(:params) do
      {
        school_name_like:
      }
    end
    let(:school_index_contract) { SchoolContracts::Index.call(params) }

    context "when schools are not cached" do
      before do
        allow(FetchSchools).to receive(:result).with(school_index_contract:).and_return(result)
        do_request
      end

      it { expect(response.parsed_body).to match(schools) }
    end

    context "when schools are cached" do
      let(:school_index_contract) { SchoolContracts::Index.call(params) }

      before do
        Rails.cache.fetch(school_index_contract.to_json) do
          schools
        end
      end

      it "does not calls FetchSchools.result" do
        expect(FetchSchools).not_to receive(:result)
        do_request
      end

      it "returns schools from cache" do
        do_request
        expect(response.parsed_body).to match(schools)
      end
    end
  end
end
