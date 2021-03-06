class CreateCountySnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table :county_snapshots do |t|
      t.references :county, foreign_key: true
      t.decimal :total_energy_saved
      t.decimal :average_daily_energy_consumption_per_user
      t.decimal :average_total_energy_saved_per_user

      t.timestamps
    end
  end
end
