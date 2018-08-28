class AddAvgDailyConsumptionPerUserToHouses < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :avg_daily_electricity_consumed_per_user, :decimal
    add_column :houses, :avg_daily_water_consumed_per_user, :decimal
    add_column :houses, :avg_daily_gas_consumed_per_user, :decimal
    add_column :houses, :avg_daily_carbon_consumed_per_user, :decimal
  end
end
