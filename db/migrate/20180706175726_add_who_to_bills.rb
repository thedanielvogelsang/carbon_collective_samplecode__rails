class AddWhoToBills < ActiveRecord::Migration[5.1]
  def change
    add_reference :electric_bills, :user, foreign_key: true, index: true
    add_reference :water_bills, :user, foreign_key: true, index: true
    add_reference :heat_bills, :user, foreign_key: true, index: true
  end
end
