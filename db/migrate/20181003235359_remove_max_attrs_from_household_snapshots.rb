class RemoveMaxAttrsFromHouseholdSnapshots < ActiveRecord::Migration[5.1]
  def change
    remove_column :household_snapshots, :max_daily_electricity_consumption, :decimal
    remove_column :household_snapshots, :max_daily_water_consumption, :decimal
    remove_column :household_snapshots, :max_daily_gas_consumption, :decimal
    remove_column :household_snapshots, :max_daily_carbon_consumption, :decimal

    add_column :household_snapshots, :electricity_out_of, :integer
    add_column :household_snapshots, :gas_out_of, :integer
    add_column :household_snapshots, :water_out_of, :integer
    add_column :household_snapshots, :carbon_out_of, :integer

  end
end
