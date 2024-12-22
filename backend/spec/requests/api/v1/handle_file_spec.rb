# frozen_string_literal: true

require "rails_helper"

RSpec.describe "HandleFiles" do
  describe "POST api/v1/import" do
    context "when CSV file is valid" do
      let(:csv_file) do
        fixture_file_upload(
          Rails.root.join("spec", "fixtures", "files", "valid_file.csv"), "text/csv"
        )
      end

      it "returns status ok" do
        post "/api/v1/import", params: { file: csv_file }
        expect(response).to have_http_status(:ok)
      end

      it "returns the correct JSON response with file rows" do
        post "/api/v1/import", params: { file: csv_file }
        expect(response.parsed_body["file_rows"]).to be_a(Hash)
      end
    end

    context "when CSV file is empty" do
      let(:empty_csv_file) do
        fixture_file_upload(
          Rails.root.join("spec", "fixtures", "files", "empty_file.csv"), "text/csv"
        )
      end

      it "returns status ok" do
        post "/api/v1/import", params: { file: empty_csv_file }
        expect(response).to have_http_status(:ok)
      end

      it "returns empty file rows in JSON" do
        post "/api/v1/import", params: { file: empty_csv_file }
        expect(response.parsed_body["file_rows"]).to be_empty
      end
    end

    context "when file is not a CSV" do
      let(:non_csv_file) do
        fixture_file_upload(
          Rails.root.join("spec", "fixtures", "files", "non_csv_file.txt"), "text/csv"
        )
      end

      it "returns status ok" do
        post "/api/v1/import", params: { file: non_csv_file }
        expect(response).to have_http_status(:ok)
      end

      it "returns the correct JSON response with file rows" do
        post "/api/v1/import", params: { file: non_csv_file }
        expect(response.body).to include("file_rows")
      end
    end
  end
end
