class AddResourceDailyAveragesToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :country_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    add_column :country_snapshots, :average_daily_water_consumption_per_user, :decimal
    add_column :country_snapshots, :average_daily_gas_consumption_per_user, :decimal
    add_column :region_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    add_column :region_snapshots, :average_daily_water_consumption_per_user, :decimal
    add_column :region_snapshots, :average_daily_gas_consumption_per_user, :decimal
    add_column :county_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    add_column :county_snapshots, :average_daily_water_consumption_per_user, :decimal
    add_column :county_snapshots, :average_daily_gas_consumption_per_user, :decimal
    add_column :neighborhood_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    add_column :neighborhood_snapshots, :average_daily_water_consumption_per_user, :decimal
    add_column :neighborhood_snapshots, :average_daily_gas_consumption_per_user, :decimal
    add_column :city_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    add_column :city_snapshots, :average_daily_water_consumption_per_user, :decimal
    add_column :city_snapshots, :average_daily_gas_consumption_per_user, :decimal
    add_column :household_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    add_column :household_snapshots, :average_daily_water_consumption_per_user, :decimal
    add_column :household_snapshots, :average_daily_gas_consumption_per_user, :decimal
  end
end
