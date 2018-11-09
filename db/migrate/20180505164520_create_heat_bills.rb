class CreateHeatBills < ActiveRecord::Migration[5.1]
  def change
    create_table :heat_bills do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.float :total_therms
      t.float :price
      t.float :gas_saved
      t.references :house, foreign_key: true

      t.timestamps
    end
  end
end
