# frozen_string_literal: true

class AddDeletedAtToApiRequestLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :api_request_logs, :deleted_at, :datetime
    add_index :api_request_logs, :deleted_at
  end
end
