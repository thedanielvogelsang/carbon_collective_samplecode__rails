class AddAttrsToHouses < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :total_electricity_consumed, :decimal, :default => "0.0"
    add_column :houses, :total_water_consumed, :decimal, :default => "0.0"
    add_column :houses, :total_gas_consumed, :decimal, :default => "0.0"
    add_column :houses, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :houses, :max_regional_avg_electricity_consumption, :decimal, :default => "0.0"
    add_column :houses, :max_regional_avg_water_consumption, :decimal, :default => "0.0"
    add_column :houses, :max_regional_avg_gas_consumption, :decimal, :default => "0.0"
    add_column :houses, :max_regional_avg_carbon_consumption, :decimal, :default => "0.0"
    add_column :houses, :electricity_rank, :integer
    add_column :houses, :water_rank, :integer
    add_column :houses, :gas_rank, :integer
    add_column :houses, :carbon_rank, :integer
    add_column :houses, :out_of, :integer
  end
end
