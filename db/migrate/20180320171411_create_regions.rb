class CreateRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :regions do |t|
      t.string :name
      t.decimal :tepc
      t.decimal :mepc
      t.decimal :tcspc
      t.decimal :mcspc
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
