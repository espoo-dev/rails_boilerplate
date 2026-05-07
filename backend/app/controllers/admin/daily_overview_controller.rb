# frozen_string_literal: true

module Admin
  class DailyOverviewController < Admin::ApplicationController
    DEFAULT_DAYS = 30
    TRACKED_ENTITIES = {
      "Users" => User,
      "API Request Logs" => ApiRequestLog
    }.freeze

    def index
      @days = parse_days(params[:days])
      @labels = build_labels(@days)
      @datasets = TRACKED_ENTITIES.map { |name, klass| build_dataset(name, klass) }
    end

    private

    def parse_days(value)
      return DEFAULT_DAYS if value.blank?

      value.to_i.clamp(7, 180)
    end

    def start_date
      Date.current - (@days - 1)
    end

    def build_labels(_days)
      (start_date..Date.current).map { |d| d.strftime("%d/%m") }
    end

    def build_dataset(label, klass)
      counts = klass
        .where(created_at: start_date.beginning_of_day..Time.current)
        .group(Arel.sql("DATE(created_at)"))
        .count

      counts_by_date = counts.transform_keys { |k| k.is_a?(String) ? Date.parse(k) : k }
      data = (start_date..Date.current).map { |d| counts_by_date[d].to_i }
      { label: label, slug: label.parameterize, data: data }
    end
  end
end
