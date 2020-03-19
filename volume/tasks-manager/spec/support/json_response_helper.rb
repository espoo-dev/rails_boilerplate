module JsonResponseHelper
  def json_response_data
    JSON.parse(response.body)['data']
  end

  def json_response_error
    JSON.parse(response.body)['error_message']
  end
end
