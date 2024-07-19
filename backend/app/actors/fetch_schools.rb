# frozen_string_literal: true

class FetchSchools < Actor
  FETCH_SCHOOLS_URL = "https://api.data.gov/ed/collegescorecard/v1/schools"

  input :school_name_like

  output :data

  def call
    fail!(error: :missing_college_score_card_api_key) if api_key.blank?

    self.data = fetch_schools
  end

  private

  def fetch_schools
    response = Faraday.get(FETCH_SCHOOLS_URL, params)
    json_response = JSON.parse(response.body)
    json_response["results"]
  end

  def params
    {
      api_key:,
      fields: "id,school.name",
      page: 0,
      "school.name" => school_name_like
    }
  end

  def api_key
    ENV.fetch("COLLEGE_SCORE_CARD_API_KEY", nil)
  end
end
