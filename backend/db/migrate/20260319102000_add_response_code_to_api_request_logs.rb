# frozen_string_literal: true

class AddResponseCodeToApiRequestLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :api_request_logs, :response_code, :integer, null: false, default: 0
    add_index :api_request_logs, :response_code
  end
end
