class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.decimal :total_electricity_saved
      t.decimal :total_gas_saved
      t.decimal :total_water_saved
      t.decimal :avg_daily_electricity_consumed_per_capita
      t.decimal :avg_daily_gas_consumed_per_capita
      t.decimal :avg_daily_water_consumed_per_capita
      t.decimal :avg_total_electricity_saved_per_user
      t.decimal :avg_total_gas_saved_per_user
      t.decimal :avg_total_water_saved_per_user
      t.decimal :avg_daily_electricity_consumed_per_user
      t.decimal :avg_daily_gas_consumed_per_user
      t.decimal :avg_daily_water_consumed_per_user
      t.references :region, foreign_key: true

      t.timestamps
    end
  end
end
