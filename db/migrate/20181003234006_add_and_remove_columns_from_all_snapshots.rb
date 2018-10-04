class AddAndRemoveColumnsFromAllSnapshots < ActiveRecord::Migration[5.1]
  def change
    remove_column :country_snapshots, :max_daily_electricity_consumption, :decimal
    remove_column :country_snapshots, :max_daily_water_consumption, :decimal
    remove_column :country_snapshots, :max_daily_gas_consumption, :decimal
    remove_column :country_snapshots, :max_daily_carbon_consumption, :decimal

    add_column :country_snapshots, :electricity_out_of, :integer
    add_column :country_snapshots, :gas_out_of, :integer
    add_column :country_snapshots, :water_out_of, :integer
    add_column :country_snapshots, :carbon_out_of, :integer

    remove_column :region_snapshots, :max_daily_electricity_consumption, :decimal
    remove_column :region_snapshots, :max_daily_water_consumption, :decimal
    remove_column :region_snapshots, :max_daily_gas_consumption, :decimal
    remove_column :region_snapshots, :max_daily_carbon_consumption, :decimal

    add_column :region_snapshots, :electricity_out_of, :integer
    add_column :region_snapshots, :gas_out_of, :integer
    add_column :region_snapshots, :water_out_of, :integer
    add_column :region_snapshots, :carbon_out_of, :integer

    remove_column :county_snapshots, :max_daily_electricity_consumption, :decimal
    remove_column :county_snapshots, :max_daily_water_consumption, :decimal
    remove_column :county_snapshots, :max_daily_gas_consumption, :decimal
    remove_column :county_snapshots, :max_daily_carbon_consumption, :decimal

    add_column :county_snapshots, :electricity_out_of, :integer
    add_column :county_snapshots, :gas_out_of, :integer
    add_column :county_snapshots, :water_out_of, :integer
    add_column :county_snapshots, :carbon_out_of, :integer

    remove_column :city_snapshots, :max_daily_electricity_consumption, :decimal
    remove_column :city_snapshots, :max_daily_water_consumption, :decimal
    remove_column :city_snapshots, :max_daily_gas_consumption, :decimal
    remove_column :city_snapshots, :max_daily_carbon_consumption, :decimal

    add_column :city_snapshots, :electricity_out_of, :integer
    add_column :city_snapshots, :gas_out_of, :integer
    add_column :city_snapshots, :water_out_of, :integer
    add_column :city_snapshots, :carbon_out_of, :integer

    remove_column :neighborhood_snapshots, :max_daily_electricity_consumption, :decimal
    remove_column :neighborhood_snapshots, :max_daily_water_consumption, :decimal
    remove_column :neighborhood_snapshots, :max_daily_gas_consumption, :decimal
    remove_column :neighborhood_snapshots, :max_daily_carbon_consumption, :decimal

    add_column :neighborhood_snapshots, :electricity_out_of, :integer
    add_column :neighborhood_snapshots, :gas_out_of, :integer
    add_column :neighborhood_snapshots, :water_out_of, :integer
    add_column :neighborhood_snapshots, :carbon_out_of, :integer
  end
end
