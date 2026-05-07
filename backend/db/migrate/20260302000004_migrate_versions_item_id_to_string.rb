# frozen_string_literal: true

class MigrateVersionsItemIdToString < ActiveRecord::Migration[8.1]
  def up
    # Clear historical version data; old bigint item_ids no longer map to any record
    execute "TRUNCATE versions;"

    change_table :versions, bulk: true do |t|
      # Change item_id from bigint to string (PaperTrail UUID support)
      t.change :item_id, :string, null: false
      t.column :uuid_id, :uuid, default: -> { "gen_random_uuid()" }, null: false
      t.remove :id
    end

    # rubocop:disable Rails/DangerousColumnNames
    rename_column :versions, :uuid_id, :id
    # rubocop:enable Rails/DangerousColumnNames
    execute "ALTER TABLE versions ADD PRIMARY KEY (id);"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
