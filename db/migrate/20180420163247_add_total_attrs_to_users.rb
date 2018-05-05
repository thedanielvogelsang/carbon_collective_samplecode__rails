class AddTotalAttrsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :total_kwhs_logged, :decimal
    add_column :users, :total_electricitybill_days_logged, :decimal
    add_column :users, :total_electricity_savings, :decimal
    add_column :users, :total_gallons_logged, :decimal
    add_column :users, :total_waterbill_days_logged, :decimal
    add_column :users, :total_water_savings, :decimal
    add_column :users, :total_therms_logged, :decimal
    add_column :users, :total_heatbill_days_logged, :decimal
    add_column :users, :total_gas_savings, :decimal
  end
end
