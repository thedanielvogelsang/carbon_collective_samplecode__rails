class ChangeTotalEnergyOnGlobals < ActiveRecord::Migration[5.1]
  def change
    remove_column :globals, :total_energy_saved, :decimal
    add_column :globals, :total_electricity_saved, :decimal 
  end
end
