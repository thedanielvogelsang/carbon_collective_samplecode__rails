class AddAttrsToRegions < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :max_regional_avg_electricity_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_regional_avg_water_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_regional_avg_gas_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_regional_avg_carbon_consumption, :decimal, :default => "0.0"

    add_column :regions, :max_regional_avg_electricity_consumption, :decimal, :default => "0.0"
    add_column :regions, :max_regional_avg_water_consumption, :decimal, :default => "0.0"
    add_column :regions, :max_regional_avg_gas_consumption, :decimal, :default => "0.0"
    add_column :regions, :max_regional_avg_carbon_consumption, :decimal, :default => "0.0"

    add_column :counties, :max_regional_avg_electricity_consumption, :decimal, :default => "0.0"
    add_column :counties, :max_regional_avg_water_consumption, :decimal, :default => "0.0"
    add_column :counties, :max_regional_avg_gas_consumption, :decimal, :default => "0.0"
    add_column :counties, :max_regional_avg_carbon_consumption, :decimal, :default => "0.0"

    add_column :cities, :max_regional_avg_electricity_consumption, :decimal, :default => "0.0"
    add_column :cities, :max_regional_avg_water_consumption, :decimal, :default => "0.0"
    add_column :cities, :max_regional_avg_gas_consumption, :decimal, :default => "0.0"
    add_column :cities, :max_regional_avg_carbon_consumption, :decimal, :default => "0.0"

    add_column :neighborhoods, :max_regional_avg_electricity_consumption, :decimal, :default => "0.0"
    add_column :neighborhoods, :max_regional_avg_water_consumption, :decimal, :default => "0.0"
    add_column :neighborhoods, :max_regional_avg_gas_consumption, :decimal, :default => "0.0"
    add_column :neighborhoods, :max_regional_avg_carbon_consumption, :decimal, :default => "0.0"
  end
end
