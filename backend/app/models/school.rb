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
class School < ApplicationRecord
  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true
  validates :lat, presence: true
  validates :lng, presence: true

  def self.from_hash(attributes)
    school = School.new

    school.name = attributes["school.name"]
    school.external_id = attributes["id"]
    school.lat = attributes["location.lat"].to_s
    school.lng = attributes["location.lon"].to_s
    school.payload = attributes.to_json
    school
  end
end
