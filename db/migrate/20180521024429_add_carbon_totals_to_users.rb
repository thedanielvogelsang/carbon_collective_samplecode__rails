class AddCarbonTotalsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :total_carbon_savings, :decimal
    add_column :users, :total_pounds_logged, :decimal
  end
end
