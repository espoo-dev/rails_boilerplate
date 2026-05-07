# frozen_string_literal: true

module Admin
  class UserLookupController < Admin::ApplicationController
    def index
      @email_query = params[:email].to_s.strip
      @user = User.find_by("email ILIKE ?", @email_query) if @email_query.present?

      if @user
        load_user_data
        load_summary_stats
      else
        load_latest_active_users
      end
    end

    private

    def load_latest_active_users
      ids_with_ts = ApiRequestLog.where.not(user_id: nil)
        .group(:user_id)
        .order(Arel.sql("MAX(started_at) DESC"))
        .limit(20)
        .pluck(:user_id, Arel.sql("MAX(started_at) AS last_activity"))
      users_by_id = User.where(id: ids_with_ts.map(&:first)).index_by(&:id)
      @latest_active_users = ids_with_ts.filter_map do |id, ts|
        user = users_by_id[id]
        [user, ts] if user
      end
    end

    def load_user_data
      @api_request_logs = @user.api_request_logs.order(started_at: :desc).limit(200)
    end

    def load_summary_stats
      @last_api_activity = @user.api_request_logs.maximum(:started_at)
      @inactive_days = @last_api_activity ? (Date.current - @last_api_activity.to_date).to_i : nil
    end
  end
end
