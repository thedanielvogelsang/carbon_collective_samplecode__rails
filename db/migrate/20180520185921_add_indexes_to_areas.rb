class AddIndexesToAreas < ActiveRecord::Migration[5.1]
  def change
    add_index :countries, :total_electricity_saved
    add_index :countries, :total_water_saved
    add_index :countries, :total_gas_saved
    add_index :regions, :total_electricity_saved
    add_index :regions, :total_water_saved
    add_index :regions, :total_gas_saved
    add_index :cities, :total_gas_saved
    add_index :cities, :total_electricity_saved
    add_index :cities, :total_water_saved
    add_index :neighborhoods, :total_electricity_saved
    add_index :neighborhoods, :total_water_saved
    add_index :neighborhoods, :total_gas_saved
  end
end
