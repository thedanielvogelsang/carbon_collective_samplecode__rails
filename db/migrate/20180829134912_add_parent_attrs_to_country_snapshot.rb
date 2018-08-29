class AddParentAttrsToCountrySnapshot < ActiveRecord::Migration[5.1]
  def change
    add_column :country_snapshots, :country_avg_carbon, :decimal
    add_column :country_snapshots, :country_avg_electricity, :decimal
    add_column :country_snapshots, :country_avg_water, :decimal
    add_column :country_snapshots, :country_avg_gas, :decimal
  end
end
