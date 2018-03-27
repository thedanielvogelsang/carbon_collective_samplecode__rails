class AddElectricitySavedToElectricBills < ActiveRecord::Migration[5.1]
  def change
    add_column :electric_bills, :electricity_saved, :float
  end
end
