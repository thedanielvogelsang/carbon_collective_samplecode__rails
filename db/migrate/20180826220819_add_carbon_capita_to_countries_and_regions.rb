class AddCarbonCapitaToCountriesAndRegions < ActiveRecord::Migration[5.1]
  def change
    add_column :countries, :avg_daily_carbon_consumed_per_capita, :decimal
    add_column :regions, :avg_daily_carbon_consumed_per_capita, :decimal
  end
end
