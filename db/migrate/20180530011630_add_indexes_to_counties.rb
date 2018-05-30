class AddIndexesToCounties < ActiveRecord::Migration[5.1]
  def change
    add_index :counties, :total_gas_saved
    add_index :counties, :total_electricity_saved
    add_index :counties, :total_water_saved
    add_index :counties, :name, :unique => true

  end
end
