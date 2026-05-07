# frozen_string_literal: true

module Admin
  class RequestsDashboardController < Admin::ApplicationController
    def index
      @users = User.order(:email)
      @email_query = params[:email].to_s.strip
      @selected_user = find_selected_user

      return unless @selected_user

      @success_requests = grouped_requests(@selected_user, success_only: true)
      @error_requests = grouped_requests(@selected_user, errors_only: true)
    end

    private

    def find_selected_user
      return User.find(params[:user_id]) if params[:user_id].present?
      return nil if @email_query.blank?

      User.where("email ILIKE ?", "%#{@email_query}%").order(:email).first
    end

    def grouped_requests(user, success_only: false, errors_only: false)
      scope = ApiRequestLog.where(user_id: user.id)
      scope = scope.where("response_code BETWEEN 200 AND 299") if success_only
      scope = scope.where.not("response_code BETWEEN 200 AND 299") if errors_only

      scope
        .select(*aggregation_columns)
        .group("http_method, endpoint, response_code, DATE(started_at)")
        .order("DATE(started_at) DESC, http_method, endpoint, response_code")
    end

    def aggregation_columns
      [
        "http_method", "endpoint", "response_code",
        "DATE(started_at) AS request_date",
        "COUNT(*) AS request_count",
        "MIN(started_at) AS first_request_at",
        "MAX(started_at) AS last_request_at"
      ]
    end
  end
end
