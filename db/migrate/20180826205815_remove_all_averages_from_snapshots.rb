class RemoveAllAveragesFromSnapshots < ActiveRecord::Migration[5.1]
  def change
    remove_column :country_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    remove_column :country_snapshots, :average_daily_water_consumption_per_user, :decimal
    remove_column :country_snapshots, :average_daily_gas_consumption_per_user, :decimal
    remove_column :region_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    remove_column :region_snapshots, :average_daily_water_consumption_per_user, :decimal
    remove_column :region_snapshots, :average_daily_gas_consumption_per_user, :decimal
    remove_column :county_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    remove_column :county_snapshots, :average_daily_water_consumption_per_user, :decimal
    remove_column :county_snapshots, :average_daily_gas_consumption_per_user, :decimal
    remove_column :city_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    remove_column :city_snapshots, :average_daily_water_consumption_per_user, :decimal
    remove_column :city_snapshots, :average_daily_gas_consumption_per_user, :decimal
    remove_column :neighborhood_snapshots, :average_daily_electricity_consumption_per_user, :decimal
    remove_column :neighborhood_snapshots, :average_daily_water_consumption_per_user, :decimal
    remove_column :neighborhood_snapshots, :average_daily_gas_consumption_per_user, :decimal
  end
end
