class CreateHouseholdSnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table :household_snapshots do |t|
      t.references :house, foreign_key: true
      t.decimal :average_daily_energy_consumption_per_resident
      t.decimal :average_total_energy_saved_per_resident
      t.decimal :total_energy_saved

      t.timestamps
    end
  end
end
