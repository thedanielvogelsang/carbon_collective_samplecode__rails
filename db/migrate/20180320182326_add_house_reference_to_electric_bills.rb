class AddHouseReferenceToElectricBills < ActiveRecord::Migration[5.1]
  def change
    add_reference :electric_bills, :house, foreign_key: true
  end
end
