# frozen_string_literal: true

module Admin
  class ApiErrorLogsController < Admin::ApplicationController
    UNKNOWN_APP_VERSION = "unknown"

    def index
      logs = filtered_logs_scope.includes(:user).order(started_at: :desc).to_a

      @app_versions = available_app_versions
      @grouped_logs = group_logs_by_response_code(logs)
      @chart_data = build_chart_data(logs)
      @chart_data_by_version = build_chart_data_by_version(logs)
    end

    private

    helper_method :filters

    def filters
      @filters ||= {
        email: params[:email].to_s.strip,
        start_date: parse_date(params[:start_date]) || 30.days.ago.to_date,
        end_date: parse_date(params[:end_date]) || Date.tomorrow,
        app_version: params[:app_version].presence
      }
    end

    def non_2xx_scope
      ApiRequestLog.where.not("response_code BETWEEN 200 AND 299")
    end

    def filtered_logs_scope
      scope = non_2xx_scope
      scope = filter_by_email(scope)
      scope = filter_by_date_range(scope)
      filter_by_app_version(scope)
    end

    def filter_by_email(scope)
      email = filters[:email].presence
      return scope unless email

      scope.joins(:user).where("users.email ILIKE ?", "%#{email}%")
    end

    def filter_by_date_range(scope)
      from = filters[:start_date]
      to = filters[:end_date]
      scope = scope.where(started_at: from.beginning_of_day..) if from
      scope = scope.where(started_at: ..to.end_of_day) if to
      scope
    end

    def filter_by_app_version(scope)
      version = filters[:app_version]
      return scope if version.blank?
      return scope.where("headers->>'App-Version' IS NULL") if version == UNKNOWN_APP_VERSION

      scope.where("headers->>'App-Version' = ?", version)
    end

    def available_app_versions
      non_2xx_scope
        .distinct
        .pluck(Arel.sql("headers->>'App-Version'"))
        .map { |version| version.presence || UNKNOWN_APP_VERSION }
        .uniq
        .sort
    end

    def group_logs_by_response_code(logs)
      logs.group_by(&:response_code).sort_by { |_code, group_logs| -group_logs.first.started_at.to_f }
    end

    def parse_date(value)
      return nil if value.blank?

      Date.parse(value)
    rescue ArgumentError
      nil
    end

    def chart_date_range
      (filters[:start_date]..filters[:end_date])
    end

    def build_chart_data(logs)
      by_code_and_date = logs.group_by(&:response_code).transform_values do |code_logs|
        counts = code_logs.group_by { |log| log.created_at.to_date }.transform_values(&:size)
        chart_date_range.each_with_object({}) { |date, h| h[date.to_s] = counts[date].to_i }
      end

      by_code_and_date.sort_by { |code, _| code }.to_h
    end

    def build_chart_data_by_version(logs)
      logs.group_by(&:response_code).sort_by { |code, _| code }.to_h.transform_values do |code_logs|
        versions_per_day_for(code_logs)
      end
    end

    def versions_per_day_for(code_logs)
      logs_by_date = code_logs.group_by { |log| log.created_at.to_date }
      chart_date_range.each_with_object({}) do |date, versions_by_date|
        versions_by_date[date.to_s] = count_versions(logs_by_date[date] || [])
      end
    end

    def count_versions(day_logs)
      day_logs.each_with_object(Hash.new(0)) { |log, counts| counts[app_version(log)] += 1 }
    end

    def app_version(log)
      log.headers&.dig("App-Version") || UNKNOWN_APP_VERSION
    end
  end
end
