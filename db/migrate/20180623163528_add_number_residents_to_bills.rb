class AddNumberResidentsToBills < ActiveRecord::Migration[5.1]
  def change
    add_column :electric_bills, :no_residents, :integer
    add_column :water_bills, :no_residents, :integer
    add_column :heat_bills, :no_residents, :integer
  end
end
