class AddEnergySavedToElectricBills < ActiveRecord::Migration[5.1]
  def change
    add_column :electric_bills, :energy_saved, :float
  end
end
