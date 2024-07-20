# frozen_string_literal: true

class SyncSchoolsOnDb < Actor
  input :schools

  output :data

  def call
    self.data = sync_schools(schools)
  end

  private

  def sync_schools(schools)
    schools.map do |school_data|
      school = School.find_by(external_id: school_data["id"])
      return school if school

      school = School.from_hash(school_data)
      school.save!
      school
    end
  end
end
