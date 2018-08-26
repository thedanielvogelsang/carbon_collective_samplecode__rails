class AddCarbonAvgsToEachRegion < ActiveRecord::Migration[5.1]
  def change
    add_column :neighborhoods, :total_carbon_saved, :decimal, :default => "0.0"
    add_column :neighborhoods, :avg_daily_carbon_consumed_per_user, :decimal, :default => "0.0"
    add_column :neighborhoods, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :cities, :total_carbon_saved, :decimal, :default => "0.0"
    add_column :cities, :avg_daily_carbon_consumed_per_user, :decimal, :default => "0.0"
    add_column :cities, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :counties, :total_carbon_saved, :decimal, :default => "0.0"
    add_column :counties, :avg_daily_carbon_consumed_per_user, :decimal, :default => "0.0"
    add_column :counties, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :regions, :total_carbon_saved, :decimal, :default => "0.0"
    add_column :regions, :avg_daily_carbon_consumed_per_user, :decimal, :default => "0.0"
    add_column :regions, :total_carbon_consumed, :decimal, :default => "0.0"
    add_column :countries, :total_carbon_saved, :decimal, :default => "0.0"
    add_column :countries, :avg_daily_carbon_consumed_per_user, :decimal, :default => "0.0"
    add_column :countries, :total_carbon_consumed, :decimal, :default => "0.0"
  end
end
