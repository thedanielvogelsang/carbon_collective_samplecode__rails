class CreateWaterBills < ActiveRecord::Migration[5.1]
  def change
    create_table :water_bills do |t|
      t.date :start_date
      t.date :end_date
      t.float :total_gallons
      t.float :price
      t.float :water_saved
      t.references :house, foreign_key: true

      t.timestamps
    end
  end
end
