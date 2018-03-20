class RemoveUsersFromElectricBills < ActiveRecord::Migration[5.1]
  def change
    remove_reference :electric_bills, :user, foreign_key: true
  end
end
