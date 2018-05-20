class AddTotalsIndexToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :total_electricity_savings
    add_index :users, :total_gas_savings
    add_index :users, :total_water_savings
  end
end
