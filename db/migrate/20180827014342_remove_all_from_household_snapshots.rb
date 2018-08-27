class RemoveAllFromHouseholdSnapshots < ActiveRecord::Migration[5.1]
  def change
    remove_column :household_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    remove_column :household_snapshots, :average_daily_water_consumption_per_user, :decimal
    remove_column :household_snapshots, :average_daily_gas_consumption_per_user, :decimal
  end
end
