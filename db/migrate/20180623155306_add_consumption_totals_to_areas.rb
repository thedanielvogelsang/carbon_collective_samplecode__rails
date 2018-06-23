class AddConsumptionTotalsToAreas < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :total_electricity_consumed, :decimal, :default => 0
    add_column :countries, :total_water_consumed, :decimal, :default => 0
    add_column :countries, :total_gas_consumed, :decimal, :default => 0
    add_column :regions, :total_electricity_consumed, :decimal, :default => 0
    add_column :regions, :total_water_consumed, :decimal, :default => 0
    add_column :regions, :total_gas_consumed, :decimal, :default => 0
    add_column :counties, :total_electricity_consumed, :decimal, :default => 0
    add_column :counties, :total_water_consumed, :decimal, :default => 0
    add_column :counties, :total_gas_consumed, :decimal, :default => 0
    add_column :cities, :total_gas_consumed, :decimal, :default => 0
    add_column :cities, :total_electricity_consumed, :decimal, :default => 0
    add_column :cities, :total_water_consumed, :decimal, :default => 0
    add_column :neighborhoods, :total_electricity_consumed, :decimal, :default => 0
    add_column :neighborhoods, :total_water_consumed, :decimal, :default => 0
    add_column :neighborhoods, :total_gas_consumed, :decimal, :default => 0

    add_index :countries, :total_electricity_consumed
    add_index :countries, :total_water_consumed
    add_index :countries, :total_gas_consumed
    add_index :regions, :total_electricity_consumed
    add_index :regions, :total_water_consumed
    add_index :regions, :total_gas_consumed
    add_index :counties, :total_electricity_consumed
    add_index :counties, :total_water_consumed
    add_index :counties, :total_gas_consumed
    add_index :cities, :total_gas_consumed
    add_index :cities, :total_electricity_consumed
    add_index :cities, :total_water_consumed
    add_index :neighborhoods, :total_electricity_consumed
    add_index :neighborhoods, :total_water_consumed
    add_index :neighborhoods, :total_gas_consumed
  end
end
