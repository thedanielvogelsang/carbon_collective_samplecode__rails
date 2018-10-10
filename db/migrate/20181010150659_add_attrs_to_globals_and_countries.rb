class AddAttrsToGlobalsAndCountries < ActiveRecord::Migration[5.1]
  def change
    # the avg use of each resource across all users will be stored on global
    add_column :globals, :avg_user_electricity_consumption, :decimal, :default => "0.0"
    add_column :globals, :avg_user_water_consumption, :decimal, :default => "0.0"
    add_column :globals, :avg_user_gas_consumption, :decimal, :default => "0.0"
    add_column :globals, :avg_user_carbon_consumption, :decimal, :default => "0.0"

    # the daily avg use MAX for users within each country will be stored on country model
    add_column :countries, :max_daily_user_electricity_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_daily_user_water_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_daily_user_gas_consumption, :decimal, :default => "0.0"
    add_column :countries, :max_daily_user_carbon_consumption, :decimal, :default => "0.0"
  end
end
