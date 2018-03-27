class RemoveCarbonSavedFromElectricBills < ActiveRecord::Migration[5.1]
  def change
    remove_column :electric_bills, :carbon_saved, :float
  end
end
