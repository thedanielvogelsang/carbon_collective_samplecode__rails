class AddAttrsToRegions < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_daily_carbon_consumption, :decimal, :default => "0.0"

    add_column :regions, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :regions, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :regions, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :regions, :max_daily_carbon_consumption, :decimal, :default => "0.0"

    add_column :counties, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :counties, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :counties, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :counties, :max_daily_carbon_consumption, :decimal, :default => "0.0"

    add_column :cities, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :cities, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :cities, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :cities, :max_daily_carbon_consumption, :decimal, :default => "0.0"

    add_column :neighborhoods, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :neighborhoods, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :neighborhoods, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :neighborhoods, :max_daily_carbon_consumption, :decimal, :default => "0.0"
  end
end
