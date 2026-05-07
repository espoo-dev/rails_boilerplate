# frozen_string_literal: true

class MigrateDeviseApiTokensToUuid < ActiveRecord::Migration[8.1]
  def up
    # All existing tokens are invalidated because resource_owner_id (bigint)
    # can no longer map to users.id (now uuid). Users must re-authenticate.
    execute "TRUNCATE devise_api_tokens;"

    # Add uuid PK column and change resource_owner_id type
    change_table :devise_api_tokens, bulk: true do |t|
      t.column :uuid_id, :uuid, default: -> { "gen_random_uuid()" }, null: false
      t.remove :resource_owner_id
      # rubocop:disable Rails/NotNullColumn
      t.column :resource_owner_id, :uuid, null: false
      # rubocop:enable Rails/NotNullColumn
      t.remove :id
    end

    # rubocop:disable Rails/DangerousColumnNames
    rename_column :devise_api_tokens, :uuid_id, :id
    # rubocop:enable Rails/DangerousColumnNames
    execute "ALTER TABLE devise_api_tokens ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
