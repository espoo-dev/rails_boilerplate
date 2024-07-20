# frozen_string_literal: true

require "rails_helper"

RSpec.describe School do
  subject { build(:school) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_uniqueness_of(:external_id) }
    it { is_expected.to validate_presence_of(:lat) }
    it { is_expected.to validate_presence_of(:lng) }
  end

  describe ".from_hash" do
    let(:school_hash) do
      {
        "school.name" => "Harvard University",
        "id" => 166_027,
        "location.lat" => 42.374471,
        "location.lon" => -71.118313
      }
    end

    it "initializes attributes from hash" do
      school = described_class.from_hash(school_hash)

      expect(school.name).to eq("Harvard University")
      expect(school.external_id).to eq(166_027)
      expect(school.lat).to eq("42.374471")
      expect(school.lng).to eq("-71.118313")
      expect(school.payload).to eq(school_hash.to_json)
      expect(school).to be_valid
      expect(school.save).to be(true)
    end
  end
end
