# frozen_string_literal: true

require Rails.root.join("app/middleware/api_request_logger_middleware")

Rails.application.config.middleware.use ApiRequestLoggerMiddleware
