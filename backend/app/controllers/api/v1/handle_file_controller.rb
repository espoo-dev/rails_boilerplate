# frozen_string_literal: true

module Api
  module V1
    class HandleFileController < Api::ApplicationController
      include HandleFileHelper

      def import
        rows = set_rows_to_json(params[:file].tempfile)
        render json: { file_rows: rows }, status: :ok
      end
    end
  end
end
