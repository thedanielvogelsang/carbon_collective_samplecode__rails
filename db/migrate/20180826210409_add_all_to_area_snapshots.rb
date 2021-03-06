class AddAllToAreaSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :country_snapshots, :avg_daily_electricity_consumption_per_user, :decimal, :default => "0.0"
    add_column :country_snapshots, :avg_daily_water_consumption_per_user, :decimal, :default => "0.0"
    add_column :country_snapshots, :avg_daily_gas_consumption_per_user, :decimal, :default => "0.0"
    add_column :country_snapshots, :avg_daily_carbon_consumption_per_user, :decimal, :default => "0.0"
    add_column :country_snapshots, :total_electricity_consumed, :decimal, :default => "0.0"
    add_column :country_snapshots, :total_water_consumed, :decimal, :default => "0.0"
    add_column :country_snapshots, :total_gas_consumed, :decimal, :default => "0.0"
    add_column :country_snapshots, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :country_snapshots, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :country_snapshots, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :country_snapshots, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :country_snapshots, :max_daily_carbon_consumption, :decimal, :default => "0.0"
    add_column :country_snapshots, :electricity_rank, :integer
    add_column :country_snapshots, :water_rank, :integer
    add_column :country_snapshots, :gas_rank, :integer
    add_column :country_snapshots, :carbon_rank, :integer
    add_column :country_snapshots, :out_of, :integer

    add_column :region_snapshots, :avg_daily_electricity_consumption_per_user, :decimal, :default => "0.0"
    add_column :region_snapshots, :avg_daily_water_consumption_per_user, :decimal, :default => "0.0"
    add_column :region_snapshots, :avg_daily_gas_consumption_per_user, :decimal, :default => "0.0"
    add_column :region_snapshots, :avg_daily_carbon_consumption_per_user, :decimal, :default => "0.0"
    add_column :region_snapshots, :total_electricity_consumed, :decimal, :default => "0.0"
    add_column :region_snapshots, :total_water_consumed, :decimal, :default => "0.0"
    add_column :region_snapshots, :total_gas_consumed, :decimal, :default => "0.0"
    add_column :region_snapshots, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :region_snapshots, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :region_snapshots, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :region_snapshots, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :region_snapshots, :max_daily_carbon_consumption, :decimal, :default => "0.0"
    add_column :region_snapshots, :electricity_rank, :integer
    add_column :region_snapshots, :water_rank, :integer
    add_column :region_snapshots, :gas_rank, :integer
    add_column :region_snapshots, :carbon_rank, :integer
    add_column :region_snapshots, :out_of, :integer

    add_column :county_snapshots, :avg_daily_electricity_consumption_per_user, :decimal, :default => "0.0"
    add_column :county_snapshots, :avg_daily_water_consumption_per_user, :decimal, :default => "0.0"
    add_column :county_snapshots, :avg_daily_gas_consumption_per_user, :decimal, :default => "0.0"
    add_column :county_snapshots, :avg_daily_carbon_consumption_per_user, :decimal, :default => "0.0"
    add_column :county_snapshots, :total_electricity_consumed, :decimal, :default => "0.0"
    add_column :county_snapshots, :total_water_consumed, :decimal, :default => "0.0"
    add_column :county_snapshots, :total_gas_consumed, :decimal, :default => "0.0"
    add_column :county_snapshots, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :county_snapshots, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :county_snapshots, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :county_snapshots, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :county_snapshots, :max_daily_carbon_consumption, :decimal, :default => "0.0"
    add_column :county_snapshots, :electricity_rank, :integer
    add_column :county_snapshots, :water_rank, :integer
    add_column :county_snapshots, :gas_rank, :integer
    add_column :county_snapshots, :carbon_rank, :integer
    add_column :county_snapshots, :out_of, :integer

    add_column :city_snapshots, :avg_daily_electricity_consumption_per_user, :decimal, :default => "0.0"
    add_column :city_snapshots, :avg_daily_water_consumption_per_user, :decimal, :default => "0.0"
    add_column :city_snapshots, :avg_daily_gas_consumption_per_user, :decimal, :default => "0.0"
    add_column :city_snapshots, :avg_daily_carbon_consumption_per_user, :decimal, :default => "0.0"
    add_column :city_snapshots, :total_electricity_consumed, :decimal, :default => "0.0"
    add_column :city_snapshots, :total_water_consumed, :decimal, :default => "0.0"
    add_column :city_snapshots, :total_gas_consumed, :decimal, :default => "0.0"
    add_column :city_snapshots, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :city_snapshots, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :city_snapshots, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :city_snapshots, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :city_snapshots, :max_daily_carbon_consumption, :decimal, :default => "0.0"
    add_column :city_snapshots, :electricity_rank, :integer
    add_column :city_snapshots, :water_rank, :integer
    add_column :city_snapshots, :gas_rank, :integer
    add_column :city_snapshots, :carbon_rank, :integer
    add_column :city_snapshots, :out_of, :integer

    add_column :neighborhood_snapshots, :avg_daily_electricity_consumption_per_user, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :avg_daily_water_consumption_per_user, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :avg_daily_gas_consumption_per_user, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :avg_daily_carbon_consumption_per_user, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :total_electricity_consumed, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :total_water_consumed, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :total_gas_consumed, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :max_daily_electricity_consumption, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :max_daily_water_consumption, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :max_daily_gas_consumption, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :max_daily_carbon_consumption, :decimal, :default => "0.0"
    add_column :neighborhood_snapshots, :electricity_rank, :integer
    add_column :neighborhood_snapshots, :water_rank, :integer
    add_column :neighborhood_snapshots, :gas_rank, :integer
    add_column :neighborhood_snapshots, :carbon_rank, :integer
    add_column :neighborhood_snapshots, :out_of, :integer
  end
end
