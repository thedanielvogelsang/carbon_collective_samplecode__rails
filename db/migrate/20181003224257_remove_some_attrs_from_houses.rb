class RemoveSomeAttrsFromHouses < ActiveRecord::Migration[5.1]
  def change
    remove_column :houses, :electricity_rank, :integer
    remove_column :houses, :water_rank, :integer
    remove_column :houses, :gas_rank, :integer
    remove_column :houses, :carbon_rank, :integer
    remove_column :houses, :out_of, :integer
  end
end
