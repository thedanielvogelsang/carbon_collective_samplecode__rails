class AddAllToHouseholdSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :household_snapshots, :avg_daily_electricity_consumption_per_user, :decimal, :default => "0.0"
    add_column :household_snapshots, :avg_daily_water_consumption_per_user, :decimal, :default => "0.0"
    add_column :household_snapshots, :avg_daily_gas_consumption_per_user, :decimal, :default => "0.0"
    add_column :household_snapshots, :avg_daily_carbon_consumption_per_user, :decimal, :default => "0.0"
    add_column :household_snapshots, :total_electricity_consumed, :decimal, :default => "0.0"
    add_column :household_snapshots, :total_water_consumed, :decimal, :default => "0.0"
    add_column :household_snapshots, :total_gas_consumed, :decimal, :default => "0.0"
    add_column :household_snapshots, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :household_snapshots, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :household_snapshots, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :household_snapshots, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :household_snapshots, :max_daily_carbon_consumption, :decimal, :default => "0.0"
    add_column :household_snapshots, :electricity_rank, :integer
    add_column :household_snapshots, :water_rank, :integer
    add_column :household_snapshots, :gas_rank, :integer
    add_column :household_snapshots, :carbon_rank, :integer
    add_column :household_snapshots, :out_of, :integer
  end
end
