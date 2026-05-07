# frozen_string_literal: true

module Admin
  class UserAnalyticsController < Admin::ApplicationController
    def index
      @start_date = parse_date(params[:start_date], 30.days.ago.to_date)
      @end_date = parse_date(params[:end_date], Date.current)
      @total_users = User.count
      @chart_data = build_chart_data
    end

    private

    def date_range
      @start_date.beginning_of_day..@end_date.end_of_day
    end

    def build_chart_data
      {
        date_labels: (@start_date..@end_date).to_a,
        users_per_day: users_per_day
      }
    end

    def users_per_day
      User.where(created_at: date_range)
        .group("DATE(created_at)")
        .count
    end

    def parse_date(value, default)
      return default if value.blank?

      Date.parse(value)
    rescue Date::Error
      default
    end
  end
end
