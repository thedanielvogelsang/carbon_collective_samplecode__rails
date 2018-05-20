class AddIndexesToBills < ActiveRecord::Migration[5.1]
  def change
    add_index :electric_bills, :electricity_saved
    add_index :water_bills, :water_saved
    add_index :heat_bills, :gas_saved
  end
end
