# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Schools" do
  describe "GET /api/v1/schools/index_fetch_only" do
    context "when data is valid" do
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

      before do
        allow(FetchSchools).to receive(:result).with(school_name_like: school_name_like).and_return(result)
        get "/api/v1/schools/index_fetch_only", params: { school_name_like: }
      end

      it { expect(response.parsed_body).to match(schools) }
    end
  end
end
