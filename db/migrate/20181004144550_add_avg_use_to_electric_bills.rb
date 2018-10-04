class AddAvgUseToElectricBills < ActiveRecord::Migration[5.1]
  def change
    add_column :electric_bills, :average_usage, :decimal
    add_column :electric_bills, :force, :boolean, :default => false
  end
end
