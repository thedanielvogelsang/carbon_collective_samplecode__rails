class AddCarbonSavedToElectricBills < ActiveRecord::Migration[5.1]
  def change
    add_column :electric_bills, :carbon_saved, :float
  end
end
