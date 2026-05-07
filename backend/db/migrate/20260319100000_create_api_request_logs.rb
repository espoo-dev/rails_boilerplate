# frozen_string_literal: true

class CreateApiRequestLogs < ActiveRecord::Migration[8.1]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :api_request_logs, id: :uuid do |t|
      t.references :user, type: :uuid, null: true, foreign_key: true
      t.string :http_method, null: false
      t.string :endpoint, null: false
      t.jsonb :headers, null: false, default: {}
      t.jsonb :payload, null: false, default: {}
      t.jsonb :response, null: false, default: {}
      t.datetime :started_at, null: false
      t.datetime :ended_at, null: false
      t.integer :duration_ms, null: false

      t.index :started_at
      t.index :endpoint
      t.timestamps
    end
  end
  # rubocop:enable Metrics/MethodLength
end
