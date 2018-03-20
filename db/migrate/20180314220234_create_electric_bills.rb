class CreateElectricBills < ActiveRecord::Migration[5.1]
  def change
    create_table :electric_bills do |t|
      t.date :start_date
      t.date :end_date
      t.float :total_kwhs

      t.timestamps
    end
  end
end
