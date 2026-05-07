# frozen_string_literal: true

class ApiRequestLoggerMiddleware
  AUTHORIZATION_HEADER = "HTTP_AUTHORIZATION"
  BEARER_PREFIX = "Bearer "

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    return @app.call(env) unless api_request?(request)

    started_at, monotonic_started_at = start_times
    payload = parse_body(request)
    status, headers, response = @app.call(env)
    response_body = collect_response_body(response)
    ended_at = Time.current

    log_request(
      {
        request:,
        env:,
        payload:,
        status:,
        response_body:,
        started_at:,
        ended_at:,
        monotonic_started_at:
      }
    )

    [status, headers, [response_body]]
  end

  private

  def start_times
    [Time.current, Process.clock_gettime(Process::CLOCK_MONOTONIC)]
  end

  # rubocop:disable Metrics/AbcSize
  def log_request(data)
    ApiRequestLog.create!(
      user_id: resolve_user_id(data[:env]),
      http_method: data[:request].request_method,
      endpoint: data[:request].fullpath,
      headers: extract_headers(data[:request]),
      payload: data[:payload],
      response_code: data[:status],
      response: build_response_payload(data[:status], data[:response_body]),
      started_at: data[:started_at],
      ended_at: data[:ended_at],
      duration_ms: elapsed_milliseconds(data[:monotonic_started_at])
    )
  end
  # rubocop:enable Metrics/AbcSize

  def api_request?(request)
    request.path.start_with?("/api/")
  end

  def parse_body(request)
    raw_body = request.raw_post
    return {} if raw_body.blank?

    return JSON.parse(raw_body) if json_content_type?(request.content_type)

    Rack::Utils.parse_nested_query(raw_body)
  rescue JSON::ParserError
    { raw: raw_body }
  end

  def json_content_type?(content_type)
    content_type.to_s.include?("application/json")
  end

  def collect_response_body(response)
    body = +""
    response.each { |chunk| body << chunk.to_s }
    response.close if response.respond_to?(:close)
    body
  end

  def build_response_payload(status, raw_response_body)
    parsed_body = (JSON.parse(raw_response_body) if raw_response_body.present?)

    {
      status: status,
      body: parsed_body
    }
  rescue JSON::ParserError
    {
      status: status,
      body: raw_response_body
    }
  end

  def elapsed_milliseconds(monotonic_started_at)
    elapsed_seconds = Process.clock_gettime(Process::CLOCK_MONOTONIC) - monotonic_started_at
    (elapsed_seconds * 1000.0).round
  end

  def extract_headers(request)
    request.headers.env
      .select { |key, _value| key.start_with?("HTTP_") || key == "CONTENT_TYPE" || key == "CONTENT_LENGTH" }
      .transform_keys do |key|
        key.delete_prefix("HTTP_").split("_").map(&:capitalize).join("-")
      end
  end

  def resolve_user_id(env)
    authorization = env[AUTHORIZATION_HEADER].to_s
    return if authorization.blank?
    return unless authorization.start_with?(BEARER_PREFIX)

    access_token = authorization.delete_prefix(BEARER_PREFIX)
    return if access_token.blank?

    Devise::Api::Token.find_by(access_token: access_token)&.resource_owner_id
  end
end
