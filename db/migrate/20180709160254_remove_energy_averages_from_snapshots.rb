class RemoveEnergyAveragesFromSnapshots < ActiveRecord::Migration[5.1]
  def change
    remove_column :country_snapshots, :average_daily_energy_consumption_per_user, :decimal
    remove_column :country_snapshots, :average_total_energy_saved_per_user, :decimal
    remove_column :country_snapshots, :total_energy_saved, :decimal
    remove_column :region_snapshots, :average_daily_energy_consumption_per_user, :decimal
    remove_column :region_snapshots, :average_total_energy_saved_per_user, :decimal
    remove_column :region_snapshots, :total_energy_saved, :decimal
    remove_column :county_snapshots, :average_daily_energy_consumption_per_user, :decimal
    remove_column :county_snapshots, :average_total_energy_saved_per_user, :decimal
    remove_column :county_snapshots, :total_energy_saved, :decimal
    remove_column :city_snapshots, :average_daily_energy_consumption_per_user, :decimal
    remove_column :city_snapshots, :average_total_energy_saved_per_user, :decimal
    remove_column :city_snapshots, :total_energy_saved, :decimal
    remove_column :neighborhood_snapshots, :average_daily_energy_consumption_per_user, :decimal
    remove_column :neighborhood_snapshots, :average_total_energy_saved_per_user, :decimal
    remove_column :neighborhood_snapshots, :total_energy_saved, :decimal
    remove_column :household_snapshots, :average_daily_energy_consumption_per_user, :decimal
    remove_column :household_snapshots, :average_total_energy_saved_per_user, :decimal
    remove_column :household_snapshots, :total_energy_saved, :decimal
  end
end
