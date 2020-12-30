# rubocop:disable Rails/HelperInstanceVariable
module Auth
  module JsonWebTokenHelper
    SECRET_KEY = Rails.application.credentials.jwt[:secret_key]

    def encode_user(user, exp = 24.hours.from_now)
      payload = {}
      payload[:exp] = exp.to_i
      payload[:user_id] = user.id

      JWT.encode(payload, SECRET_KEY)
    end

    def decode_token(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    end

    def header_for_user(user)
      { 'Authorization' => encode_user(user) }
    end

    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        @current_user = user_by_token(header)
      rescue ActiveRecord::RecordNotFound => e
        render_unauthorized(e.message)
      rescue JWT::DecodeError
        render_unauthorized
      end
    end

    def public_request
      header = request.headers['Authorization']
      return unless header

      header = header.split(' ').last
      begin
        @current_user = user_by_token(header)
      rescue JWT::DecodeError => e
        render_unauthorized(e.message)
      end
    end

    def user_by_token(token)
      decoded = decode_token(token)
      User.find(decoded[:user_id])
    end

    def current_user
      @current_user
    end
  end
end
# rubocop:enable Rails/HelperInstanceVariable
