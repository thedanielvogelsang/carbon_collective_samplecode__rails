class CreateRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :regions do |t|
      t.string :name
      t.decimal :total_energy_saved
      t.decimal :avg_daily_energy_consumed_per_capita
      t.decimal :avg_total_energy_saved_per_capita
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
