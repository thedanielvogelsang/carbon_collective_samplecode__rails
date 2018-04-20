class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.decimal :total_energy_saved
      t.decimal :avg_daily_energy_consumed_per_capita
      t.decimal :avg_total_energy_saved_per_capita
      t.timestamps
    end
  end
end
