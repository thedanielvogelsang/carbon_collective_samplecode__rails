class CreateNeighborhoods < ActiveRecord::Migration[5.1]
  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.decimal :tepc
      t.decimal :mepc
      t.decimal :tcspc
      t.decimal :mcspc
      t.references :city, foreign_key: true

      t.timestamps
    end
  end
end
