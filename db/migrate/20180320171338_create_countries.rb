class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.decimal :total_electricity_saved, :default => "0.0"
      t.decimal :total_gas_saved, :default => "0.0"
      t.decimal :total_water_saved, :default => "0.0"
      t.decimal :avg_daily_electricity_consumed_per_capita
      t.decimal :avg_daily_gas_consumed_per_capita
      t.decimal :avg_daily_water_consumed_per_capita
      t.decimal :avg_total_electricity_saved_per_user, :default => "0.0"
      t.decimal :avg_total_gas_saved_per_user, :default => "0.0"
      t.decimal :avg_total_water_saved_per_user, :default => "0.0"
      t.decimal :avg_daily_electricity_consumed_per_user, :default => "0.0"
      t.decimal :avg_daily_gas_consumed_per_user, :default => "0.0"
      t.decimal :avg_daily_water_consumed_per_user, :default => "0.0"
      t.timestamps
    end
  end
end
