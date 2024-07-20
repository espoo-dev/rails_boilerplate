# frozen_string_literal: true

class CreateSchools < ActiveRecord::Migration[7.1]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.bigint :external_id, null: false
      t.string :lat, null: false
      t.string :lng, null: false
      t.jsonb :payload, default: {}
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :schools, :external_id, unique: true
  end
end
