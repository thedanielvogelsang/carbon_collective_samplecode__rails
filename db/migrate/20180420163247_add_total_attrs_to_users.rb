class AddTotalAttrsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :total_kwhs_logged, :decimal
    add_column :users, :total_days_logged, :decimal
    add_column :users, :total_electricity_savings, :decimal
  end
end
