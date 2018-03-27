class RemoveEnergySavedFromElectricBills < ActiveRecord::Migration[5.1]
  def change
    remove_column :electric_bills, :energy_saved, :float
  end
end
