class AddPriceToElectricBills < ActiveRecord::Migration[5.1]
  def change
    add_column :electric_bills, :price, :float
  end
end
