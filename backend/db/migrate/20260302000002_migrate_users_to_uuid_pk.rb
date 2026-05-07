# frozen_string_literal: true

class MigrateUsersToUuidPk < ActiveRecord::Migration[8.1]
  def up
    change_table :users, bulk: true do |t|
      t.column :uuid_id, :uuid, default: -> { "gen_random_uuid()" }, null: false
    end

    change_table :users, bulk: true do |t|
      t.remove :id
    end

    # rubocop:disable Rails/DangerousColumnNames
    rename_column :users, :uuid_id, :id
    # rubocop:enable Rails/DangerousColumnNames

    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
