# frozen_string_literal: true

# == Schema Information
#
# Table name: schools
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  lat         :string           not null
#  lng         :string           not null
#  name        :string           not null
#  payload     :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :bigint           not null
#
# Indexes
#
#  index_schools_on_external_id  (external_id) UNIQUE
#
FactoryBot.define do
  factory :school do
    name { "Harvard University" }
    external_id { 166_027 }
    lat { "42.374471" }
    lng { "-71.118313" }
    payload do
      { "school.name" => "Harvard University",
        "id" => 166_027,
        "location.lat" => 42.374471,
        "location.lon" => -71.118313 }
    end
  end
end
