# frozen_string_literal: true

module Admin
  class RequestLogsByPayloadController < Admin::ApplicationController
    def index
      @group_by = params[:group_by].presence_in(%w[payload response]) || "payload"
      @selected_date = params[:date].presence
      @grouped_logs = fetch_grouped_logs
      @daily_totals = fetch_daily_totals
    end

    def details
      @logs = fetch_detail_logs
      @filter_description = build_filter_description
    end

    private

    def fetch_grouped_logs
      scoped_logs
        .joins("LEFT JOIN users ON users.id = api_request_logs.user_id")
        .select(*grouped_select_columns)
        .group(grouped_by_sql)
        .order(Arel.sql("DATE(api_request_logs.started_at) DESC, COUNT(*) DESC"))
        .to_a
    end

    def group_value_column
      @group_by == "response" ? "api_request_logs.response" : "api_request_logs.payload"
    end

    def grouped_select_columns
      col = group_value_column
      [
        "#{col} AS group_value", "MD5(#{col}::text) AS group_digest",
        "api_request_logs.response_code",
        "DATE(api_request_logs.started_at) AS request_date",
        "COALESCE(users.email, 'anonymous') AS user_email",
        "api_request_logs.headers->>'App-Version' AS app_version",
        "COUNT(*) AS request_count"
      ]
    end

    def grouped_by_sql
      "#{group_value_column}, api_request_logs.response_code, " \
        "DATE(api_request_logs.started_at), COALESCE(users.email, 'anonymous'), " \
        "api_request_logs.headers->>'App-Version'"
    end

    def fetch_daily_totals
      scoped_logs.group("DATE(started_at)").order("DATE(started_at) DESC").count
    end

    def scoped_logs
      scope = non_2xx_logs_scope
      scope = scope.where("DATE(api_request_logs.started_at) = ?", @selected_date) if @selected_date.present?
      scope
    end

    def non_2xx_logs_scope
      ApiRequestLog
        .where.not("response_code BETWEEN 200 AND 299")
        .where(api_request_logs: { started_at: 10.days.ago.beginning_of_day.. })
    end

    def fetch_detail_logs
      scope = non_2xx_logs_scope.eager_load(:user)
      scope = scope.where("DATE(api_request_logs.started_at) = ?", params[:date]) if params[:date].present?
      scope = scope.where(response_code: params[:response_code]) if params[:response_code].present?
      scope = scope.where("COALESCE(users.email, 'anonymous') = ?", params[:user_email]) if params[:user_email].present?

      if params[:group_by] == "response" && params[:group_digest].present?
        scope = scope.where("MD5(api_request_logs.response::text) = ?", params[:group_digest])
      elsif params[:group_digest].present?
        scope = scope.where("MD5(api_request_logs.payload::text) = ?", params[:group_digest])
      end

      scope.order(started_at: :desc).limit(200)
    end

    def build_filter_description
      parts = []
      parts << "Date: #{params[:date]}" if params[:date].present?
      parts << "Response code: #{params[:response_code]}" if params[:response_code].present?
      parts << "User: #{params[:user_email]}" if params[:user_email].present?
      parts << "Grouped by: #{params[:group_by] || 'payload'}" if params[:group_digest].present?
      parts.join(" | ")
    end
  end
end
