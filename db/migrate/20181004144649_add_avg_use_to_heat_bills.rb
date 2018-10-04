class AddAvgUseToHeatBills < ActiveRecord::Migration[5.1]
  def change
    add_column :heat_bills, :average_daily_usage, :decimal
    add_column :heat_bills, :force, :boolean, :default => false
  end
end
