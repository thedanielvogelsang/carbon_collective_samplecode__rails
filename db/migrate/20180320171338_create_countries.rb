class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.decimal :tepc
      t.decimal :mepc
      t.decimal :tcspc
      t.decimal :mcspc

      t.timestamps
    end
  end
end
