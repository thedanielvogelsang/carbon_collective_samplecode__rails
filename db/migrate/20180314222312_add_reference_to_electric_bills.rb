class AddReferenceToElectricBills < ActiveRecord::Migration[5.1]
  def change
    add_reference :electric_bills, :user, foreign_key: true
  end
end
