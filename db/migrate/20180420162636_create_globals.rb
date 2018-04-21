class CreateGlobals < ActiveRecord::Migration[5.1]
  def change
    create_table :globals do |t|
      t.decimal :total_energy_saved
      t.decimal :total_water_saved
      t.decimal :total_carbon_saved

      t.timestamps
    end
  end
end
