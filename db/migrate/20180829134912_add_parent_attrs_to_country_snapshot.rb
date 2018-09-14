class AddParentAttrsToCountrySnapshot < ActiveRecord::Migration[5.1]
  def change
    add_column :country_snapshots, :country_avg_carbon, :decimal, :default => "0.0"
    add_column :country_snapshots, :country_avg_electricity, :decimal, :default => "0.0"
    add_column :country_snapshots, :country_avg_water, :decimal, :default => "0.0"
    add_column :country_snapshots, :country_avg_gas, :decimal, :default => "0.0"
  end
end
