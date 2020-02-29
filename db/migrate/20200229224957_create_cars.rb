class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.string :model
      t.decimal :price

      t.timestamps
    end
  end
end
