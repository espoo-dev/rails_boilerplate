# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncSchoolsOnDb, type: :actor do
  describe "#call" do
    subject { described_class.call(schools: schools_data) }

    let(:new_school_data) do
      {
        "school.name" => "New School",
        "id" => "123456",
        "location.lat" => 35.6895,
        "location.lon" => 139.6917
      }
    end
    let(:existing_school_data) do
      {
        "school.name" => "Existing School",
        "id" => "166027",
        "location.lat" => 42.374471,
        "location.lon" => -71.118313
      }
    end
    let(:schools_data) { [new_school_data, existing_school_data] }

    context "when no school exists" do
      it "creates both schools" do
        is_expected.to change(School, :count).by(2)
      end
    end

    context "when only one school exists" do
      let(:existing_school) do
        create(:school, external_id: "166027", name: "Existing School", lat: "42.374471", lng: "-71.118313")
      end

      it "creates only one school" do
        is_expected.to change(School, :count).by(1)
      end
    end
  end
end
