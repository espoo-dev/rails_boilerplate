# frozen_string_literal: true

module Api
  module V1
    class SchoolsController < Api::V1::ApiController
      skip_before_action :authenticate_devise_api_token!
      skip_after_action :verify_authorized

      def index
        schools = Rails.cache.fetch(school_index_contract.to_json) do
          FetchSchools.result(school_index_contract:).data
        end
        render json: schools, status: :ok
      end

      private

      def school_index_contract
        @school_index_contract ||= SchoolContracts::Index.call(permitted_params(:school_name_like))
      end

      def school_name_like
        school_index_contract[:school_name_like]
      end
    end
  end
end
